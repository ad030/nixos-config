{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "slskd";
  uid = 2001;

  # https://hub.docker.com/r/slskd/slskd
  image = "docker.io/slskd/slskd";
  tag = "0.26.2";
  digest = "sha256:d0963a3e5b16facd295bf4f2156dad0182f246b1b21a032cae12f5494c694843";

  domain = "home.4384381.xyz";
  subdomain = "slskd.${domain}";
  backend = "http://127.0.0.1:${toString ports.web}";

  ports = {
    web = 5030;
    soulseek = 50300;
  };

  directories = {
    music = "/srv/media/tank/Music/Music";
    incompleteDownloads = "/srv/downloads/slskd";
    completeDownloads = "/srv/media/tank/Downloads/slskd";
  };
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      interfaces = {
        lan = builtins.attrNames config.networking.interfaces;
        wg = builtins.attrNames config.networking.wireguard.interfaces;
      };
      auth = top.config.flake.lib.nginx-tinyauth;
    in
    {
      imports = with top.config.flake.modules.nixos; [
        containers
      ];

      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
          extraGroups = [
            "media"
          ];
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      systemd.tmpfiles.settings."${serviceName}-config" = {
        "${directories.incompleteDownloads}".d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
        "${directories.completeDownloads}".d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
      };

      services.nginx.virtualHosts = {
        ${subdomain} = {
          locations = {
            "/" = {
              proxyPass = backend;
              recommendedProxySettings = true;
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      sops.secrets."slskd/env" = {
        sopsFile = "${self}/secrets/containers.yaml";
        owner = serviceName;
      };

      networking.firewall = {
        allowedTCPPorts = [
          ports.soulseek
        ];
        allowedUDPPorts = [ ];
      };
    };

  flake.modules.homeManager."containers-${serviceName}" =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      configurationYaml = import ./_slskd-yml.nix { inherit pkgs domain; };
      # configurationYaml = ./slskd.yml;
    in
    {
      home.username = serviceName;
      home.homeDirectory = "/home/${serviceName}";
      home.stateVersion = "26.05";

      # generate xdg directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          ${serviceName} = {
            image = "${image}:${tag}@${digest}";
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/app"
              "${configurationYaml}:/app/slskd.yml:ro"

              "${directories.music}:/media/music:ro"
              "${directories.incompleteDownloads}:/downloads/incomplete"
              "${directories.completeDownloads}:/downloads/complete"
            ];
            ports = [
              "127.0.0.1:${toString ports.web}:5030/tcp"
              "${toString ports.soulseek}:50300/tcp"
            ];
            environmentFile = [
              "${osConfig.sops.secrets."slskd/env".path}"
            ];
            environment = {
              SLSKD_CONFIG = "/app/slskd.yml";
              SLSKD_DOWNLOADS_DIR = "/downloads/complete";
              SLSKD_INCOMPLETE_DIR = "/downloads/incomplete";
              SLSKD_SHARED_DIR = "/media/music";
            };
            extraPodmanArgs = [ "--group-add=keep-groups" ];
            autoStart = true;
          };
        };
      };
    };

}

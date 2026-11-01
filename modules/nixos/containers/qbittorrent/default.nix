{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "qbittorrent";
  uid = 2007;

  image = "lscr.io/linuxserver/qbittorrent";
  tag = "5.3.0";
  digest = "sha256:75ecbb1c89ab7b0a21c4bde40b4820e4f1649d2d56d83b91913422155e8d2a5f";

  domain = "4384381.xyz";
  subdomain = "qbittorrent.${domain}";
  webPort = "8090";

  directories = {
    incompleteDownloads = "/srv/downloads/qbittorrent";
    completeDownloads = "/srv/media/tank/Downloads/qbittorrent";
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

      systemd.tmpfiles.settings."qbittorrent-config" = {
        ${directories.incompleteDownloads}.d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
        ${directories.completeDownloads}.d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
      };

      services.nginx.virtualHosts = {
        ${subdomain} = {
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${webPort}";
              recommendedProxySettings = true;
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
        };
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
            userNS = "keep-id";
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/config"

              "${directories.completeDownloads}:/downloads/complete"
              "${directories.incompleteDownloads}:/downloads/incomplete"
            ];
            ports = [
              "6881:6881/tcp"
              "6881:6881/udp"
              "127.0.0.1:8090:8090/tcp"
            ];
            environment = {
              PUID = "${toString osConfig.users.users.${serviceName}.uid}";
              PGID = "${toString osConfig.users.groups.${serviceName}.gid}";
              PAGID = "${toString osConfig.users.groups.media.gid}";
              QBT_LEGAL_NOTICE = "confirm";
              QBT_TORRENTING_PORT = "6881";
              QBT_WEBUI_PORT = "8090";
              TZ = "America/New_York";
            };
            autoStart = true;
          };
        };
      };
    };
}

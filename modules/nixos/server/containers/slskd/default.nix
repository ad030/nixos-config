{
  self,
  inputs,
  ...
}:
let
  serviceName = "slskd";

  directories = {
    music = "/srv/media/tank/Music/Music";
    incompleteDownloads = "/srv/downloads/slskd";
    completeDownloads = "/srv/media/tank/Downloads/slskd";
  };

  uid = 2001;
  webPort = "5030";
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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

      systemd.tmpfiles.settings."slskd-config" = {
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
        "slskd.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      sops.secrets."slskd/env" = {
        owner = serviceName;
      };

      networking.firewall.allowedTCPPorts = [
        50300
      ];
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
      # need to do this in order to set up webhooks declaratively
      # following the nixpkgs config
      # https://github.com/nixos/nixpkgs/blob/master/nixos/modules/services/web-apps/slskd.nix
      settingsFormat = pkgs.formats.yaml { };
      configurationYaml = settingsFormat.generate "slskd.yml" {
        integrations = {
          webhooks = {
            message_webhook = {
              on = [ "PrivateMessageReceived" ];
              call = {
                url = "http://127.0.0.1:8082/slskd-message";
                headers = [
                  {
                    name = "Title";
                    value = "slskd: New message";
                  }
                  {
                    name = "Priority";
                    value = "default";
                  }
                ];
                ignore_certificate_errors = true;
              };
            };
          };
        };
      };
    in
    {
      home.username = serviceName;
      home.homeDirectory = "/home/${serviceName}";
      home.stateVersion = "26.05";

      # generate data and cache directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };
      xdg.cacheFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          slskd = {
            image = "docker.io/slskd/slskd:0.26.0@sha256:ecd4026d4f8fb504e2cc55323efa2c1f5b56d20d3686b018249cc36b48ea17a6";
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/app"
              "${configurationYaml}:/app/slskd.yml:ro"
              "${directories.music}:/media/music:ro"
              "${directories.incompleteDownloads}:/downloads/incomplete"
              "${directories.completeDownloads}:/downloads/complete"
            ];
            ports = [
              "127.0.0.1:5030:5030/tcp"
              "50300:50300/tcp"
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
          };
        };
      };
    };

}

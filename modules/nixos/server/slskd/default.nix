{
  self,
  inputs,
  ...
}:

{
  flake.modules.nixos.slskd =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "slskd";
      directories = {
        music = "/srv/media/tank/Music/Music";
        config = "/srv/config/slskd";

        incompleteDownloads = "/srv/downloads/slskd";
        completeDownloads = "/srv/media/tank/Downloads/slskd";
      };

      ids = {
        group = {
          media = 3333;
        };
        user = {
          ${username} = 2001;
        };
      };

      webPort = "5030";

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
      virtualisation.oci-containers.containers = {
        slskd = {
          image = "docker.io/slskd/slskd:0.26.0@sha256:ecd4026d4f8fb504e2cc55323efa2c1f5b56d20d3686b018249cc36b48ea17a6";
          hostname = "slskd";
          user = "${toString config.users.users.${username}.uid}:${
            toString config.users.groups.${username}.gid
          }";
          volumes = [
            "${directories.config}:/app"
            "${configurationYaml}:/config/slskd.yml:ro"
            "${directories.music}:/media/music:ro"
            "${directories.incompleteDownloads}:/downloads/incomplete"
            "${directories.completeDownloads}:/downloads/complete"
          ];
          ports = [
            "127.0.0.1:5030:5030/tcp"
            "50300:50300/tcp"
          ];
          environmentFiles = [
            "${config.sops.secrets."slskd/env".path}"
          ];
          environment = {
            SLSKD_CONFIG = "/config/slskd.yml";
            SLSKD_DOWNLOADS_DIR = "/downloads/complete";
            SLSKD_INCOMPLETE_DIR = "/downloads/incomplete";
            SLSKD_SHARED_DIR = "/media/music";
          };
          extraOptions = [
            "--group-add=${toString config.users.groups.media.gid}"
          ];
        };
      };

      systemd.tmpfiles.settings."slskd-config" = {
        "${directories.incompleteDownloads}".d = {
          user = username;
          group = "media";
          mode = "2775";
        };
        "${directories.completeDownloads}".d = {
          user = username;
          group = "media";
          mode = "2775";
        };
        "${directories.config}".d = {
          user = username;
          group = username;
          mode = "0750";
        };
      };

      users = {
        users.${username} = {
          uid = ids.user.${username};
          isNormalUser = true;
        };
        groups.${username}.gid = ids.user.${username};
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

      sops.secrets."slskd/env" = { };

      networking.firewall.allowedTCPPorts = [
        5030
        50300
      ];

    };
}

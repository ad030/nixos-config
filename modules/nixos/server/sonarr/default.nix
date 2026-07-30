{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sonarr =
    {
      config,
      lib,
      ...
    }:
    let
      mediaGid = 3333;
      ports = {
        tcp = [
          8989 # web ui
        ];
        udp = [ ];
      };

      showsDir = "/srv/media/tank/Shows";
      completeDir = "/srv/media/tank/Downloads";
      incompleteDir = "/srv/downloads";
    in
    {
      systemd.tmpfiles.settings."media-downloads" = {
        "${completeDir}/sonarr".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
        "${incompleteDir}/sonarr".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
      };

      services.nginx.virtualHosts = {
        "sonarr.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.11:8989";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      sops.secrets."sonarr/env" = { };

      containers.sonarr = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.11";

        privateUsers = "pick";

        forwardPorts =
          map (p: {
            hostPort = p;
            protocol = "tcp";
          }) ports.tcp
          ++ map (p: {
            hostPort = p;
            protocol = "udp";
          }) ports.udp;

        # no id map option yet, workaround
        # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
        bindMounts = {
          "/media/shows" = {
            mountPoint = "/media/shows:idmap";
            hostPath = showsDir;
            isReadOnly = false;
          };
          "/downloads/complete" = {
            mountPoint = "/downloads:idmap";
            hostPath = "${completeDir}/sonarr";
            isReadOnly = false;
          };
          "/downloads/incomplete" = {
            mountPoint = "/downloads:idmap";
            hostPath = "${incompleteDir}/sonarr";
            isReadOnly = false;
          };
        };

        extraFlags = [
          "--load-credential=sonarr-env:${config.sops.secrets."sonarr/env".path}"
        ];

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            users.groups.media.gid = mediaGid;

            services.sonarr = {
              enable = true;

              group = "media";

              environmentFiles = [
                "/run/credentials/@system/sonarr-env"
              ];

              settings = {
                server.port = 8989;
              };
            };

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

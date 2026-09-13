{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.radarr =
    {
      config,
      lib,
      ...
    }:
    let
      mediaGid = 3333;
      ports = {
        tcp = [
          7878 # web ui
        ];
        udp = [ ];
      };

      moviesDir = "/srv/media/tank/Movies";
      completeDir = "/srv/media/tank/Downloads";
      incompleteDir = "/srv/downloads";

      localAddr = "10.0.0.8";
      webPort = "7878";
    in
    {
      systemd.tmpfiles.settings."media-downloads" = {
        "${completeDir}/radarr".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
        "${incompleteDir}/radarr".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
      };

      services.nginx.virtualHosts = {
        "radarr.home.lan" = {
          locations."/" = {
            proxyPass = "http://${localAddr}:${webPort}";
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

      sops.secrets."radarr/env" = { };

      containers.radarr = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = localAddr;

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
          "/media/movies" = {
            mountPoint = "/media/movies:idmap";
            hostPath = moviesDir;
            isReadOnly = false;
          };
          "/downloads/complete" = {
            mountPoint = "/downloads/complete:idmap";
            hostPath = "${completeDir}/radarr";
            isReadOnly = false;
          };
          "/downloads/incomplete" = {
            mountPoint = "/downloads/incomplete:idmap";
            hostPath = "${incompleteDir}/radarr";
            isReadOnly = false;
          };
        };

        extraFlags = [
          "--load-credential=radarr-env:${config.sops.secrets."radarr/env".path}"
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

            services.radarr = {
              enable = true;

              group = "media";

              environmentFiles = [
                "/run/credentials/@system/radarr-env"
              ];

              settings = {
                server.port = 7878;
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

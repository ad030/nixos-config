{ self, inputs, ... }:
{
  flake.modules.nixos.qbittorrent =
    { pkgs, lib, ... }:
    let
      inherit (self.lib.server) mkMediaUser;
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/qbittorrent".d = {
          user = "qbittorrent";
          group = "qbittorrent";
          mode = "0750";
        };
        "/srv/downloads/qbittorrent".d = {
          user = "qbittorrent";
          group = "qbittorrent";
          mode = "0750";
        };
      };

      users = mkMediaUser {
        name = "qbittorrent";
        uid = 3007;
      };

      services.nginx.virtualHosts = {
        "qbittorrent.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.7:8090";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };

      containers.qbittorrent = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.7";

        privateUsers = false; # use host uid and gid

        forwardPorts = [
          {
            hostPort = 6881; # torrenting port
            protocol = "tcp";
          }
          {
            hostPort = 6881; # torrenting port
            protocol = "udp";
          }
          # {
          #   hostPort = 8090; # webui port
          #   protocol = "tcp";
          # }
        ];

        bindMounts = {
          "/srv/qbittorrent" = {
            hostPath = "/srv/qbittorrent";
            isReadOnly = false;
          };
          "/downloads/incomplete" = {
            hostPath = "/srv/downloads/qbittorrent";
            isReadOnly = false;
          };
          "/downloads/complete" = {
            hostPath = "/srv/media/tank/Downloads/qbittorrent";
            isReadOnly = false;
          };
        };

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            services.qbittorrent = {
              enable = true;
              package = pkgs.qbittorrent-nox;

              profileDir = "/srv/qbittorrent";

              user = "qbittorrent";
              group = "qbittorrent";

              torrentingPort = 6881;
              webuiPort = 8090;

              serverConfig = {
                BitTorrent = {
                  Session = {
                    GlobalUPSpeedLimit = "100";
                    DefaultSavePath = "/downloads/complete";
                    TempPath = "/downloads/incomplete";
                    TempPathEnabled = "true";
                  };
                };
                Preferences = {
                  WebUI = {
                    Password_PBKDF2 = "@ByteArray(1f+GZ4bqvo93Lgp/d3//FA==:Thyh7U5F+vC3d7VEQ/aIwShyzg6ssb/2Qy4JwD5dM4ycyFLDK5Nu/DxScj2R7u56q36jLxCd1vn7ql5iThHzvA==)";
                  };
                };
              };
            };

            networking.firewall = {
              allowedTCPPorts = [
                6881
                8090
              ];
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

{ self, inputs, ... }:
{
  flake.modules.nixos.qbittorrent =
    { pkgs, lib, ... }:
    let
      mediaGid = 3333;
      ports = {
        tcp = [
          6881 # torrenting port
          8090 # web ui
        ];
        udp = [
          6881 # torrenting port
        ];
      };

      incompleteDir = "/srv/downloads";
      completeDir = "/srv/media/tank/Downloads";
    in
    {
      systemd.tmpfiles.settings."media-downloads" = {
        "${completeDir}/qbittorrent".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
        "${incompleteDir}/qbittorrent".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
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

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
        allowedUDPPorts = ports.udp;
      };

      services.tailscale.serve.services = {
        qbittorrent = {
          advertised = true;
          endpoints = {
            "tcp:8090" = "http://10.0.0.7:8090";
          };
        };
      };

      containers.qbittorrent = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.7";

        privateUsers = "pick";

        forwardPorts = lib.concatLists (
          lib.mapAttrsToList (
            pr: ps: # protocol, ports to open for this protocol
            map (p: {
              hostPort = p;
              protocol = pr;
            }) ps
          ) ports
        );

        # no id map option yet, workaround
        # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
        bindMounts = {
          "/downloads/incomplete" = {
            mountPoint = "/downloads/incomplete:idmap";
            hostPath = "${incompleteDir}/qbittorrent";
            isReadOnly = false;
          };
          "/downloads/complete" = {
            mountPoint = "/downloads/complete:idmap";
            hostPath = "${completeDir}/qbittorrent";
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
            users.groups.media.gid = mediaGid;

            services.qbittorrent = {
              enable = true;
              package = pkgs.qbittorrent-nox;

              group = "media";

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
              allowedTCPPorts = ports.tcp;
              allowedUDPPorts = ports.udp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

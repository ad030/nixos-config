{
  self,
  inputs,
  ...
}:

{
  flake.modules.nixos.slskd =
    { config, ... }:
    let
      inherit (self.lib.server) mkMediaUser;
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/slskd".d = {
          user = "slskd";
          group = "slskd";
          mode = "0750";
        };
        "/srv/downloads/slskd".d = {
          user = "slskd";
          group = "slskd";
          mode = "0750";
        };
      };

      users = mkMediaUser {
        name = "slskd";
        uid = 3003;
      };

      services.nginx.virtualHosts = {
        "slskd.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.3:5030";
            recommendedProxySettings = true;
          };
        };
      };

      sops.secrets."slskd/env" = {
        owner = "slskd";
      };

      containers.slskd = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.3";

        privateUsers = false; # use host uid and gid

        forwardPorts = [
          {
            hostPort = 5030; # http web ui
            protocol = "tcp";
          }
          {
            hostPort = 5031; # https web ui
            protocol = "tcp";
          }
          {
            hostPort = 50300; # soulseek connections
            protocol = "tcp";
          }
        ];

        # pass env file into container
        bindMounts = {
          "/run/secrets/slskd/env" = {
            hostPath = config.sops.secrets."slskd/env".path;
            isReadOnly = true;
          };
          "/var/lib/slskd" = {
            hostPath = "/srv/slskd";
            isReadOnly = false;
          };
          "/media/music" = {
            hostPath = "/srv/media/tank/Music/Music";
            isReadOnly = true;
          };
          "/downloads/incomplete" = {
            hostPath = "/srv/downloads/slskd";
            isReadOnly = false;
          };
          "/downloads/complete" = {
            hostPath = "/srv/media/tank/Downloads/slskd";
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
            services.slskd = {
              enable = true;

              user = "slskd";
              group = "slskd";
              environmentFile = "/run/secrets/slskd/env";

              settings = {
                web.port = 5030;

                directories = {
                  downloads = "/downloads/complete";
                  incomplete = "/downloads/incomplete";
                };

                shares = {
                  directories = [
                    "/media/music"
                  ];
                };

                soulseek = {
                  listen_port = 50300;
                  description = ''
                    A slskd user. https://github.com/slskd/slskd. 
                          Be considerate of others 👍
                  '';
                };
              };
            };

            networking.firewall = {
              allowedTCPPorts = [
                5030
                5031
                50300
              ];
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

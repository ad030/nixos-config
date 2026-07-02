{
  self,
  inputs,
  ...
}:

{
  flake.modules.nixos.slskd =
    { config, ... }:
    let
      mediaGid = 3333;
    in
    {
      systemd.tmpfiles.settings."media-downloads" = {
        "/srv/downloads/slskd".d = {
          user = "root";
          group = "media";
          mode = "0775";
        };
      };

      services.nginx.virtualHosts = {
        "slskd.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.3:5030";
            recommendedProxySettings = true;
          };
        };
      };

      sops.secrets."slskd/env" = { };

      containers.slskd = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.3";

        privateUsers = "pick";

        forwardPorts = [
          {
            hostPort = 5030; # http web ui
            protocol = "tcp";
          }
          {
            hostPort = 50300; # soulseek connections
            protocol = "tcp";
          }
        ];

        # no id map option yet, workaround
        # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
        bindMounts = {
          "/media/music" = {
            mountPoint = "/media/music:idmap";
            hostPath = "/srv/media/tank/Music/Music";
            isReadOnly = true;
          };
          "/downloads/incomplete" = {
            mountPoint = "/downloads/incomplete:idmap";
            hostPath = "/srv/downloads/slskd";
            isReadOnly = false;
          };
          "/downloads/complete" = {
            mountPoint = "/downloads/complete:idmap";
            hostPath = "/srv/media/tank/Downloads/slskd";
            isReadOnly = false;
          };
        };

        # pass sops secret into container using systemd loadcredential
        # https://github.com/Mic92/sops-nix/issues/514#issuecomment-2036359239
        extraFlags = [
          "--load-credential=slskd-env:${config.sops.secrets."slskd/env".path}"
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

            services.slskd = {
              enable = true;

              group = "media";

              environmentFile = "/run/credentials/slskd.service/env";

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

            # needed to pass sops secret into service
            systemd.services.slskd.serviceConfig.LoadCredential = "env:slskd-env";

            networking.firewall = {
              allowedTCPPorts = [
                5030
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

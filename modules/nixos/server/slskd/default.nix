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
      mediaGid = 3333;
      ports = {
        tcp = [
          5030 # webui
          50300 # soulseek network
        ];
        udp = [ ];
      };

      incompleteDir = "/srv/downloads";
      completeDir = "/srv/media/tank/Downloads";
      musicDir = "/srv/media/tank/Music/Music";
    in
    {
      systemd.tmpfiles.settings."media-downloads" = {
        "${incompleteDir}/slskd".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
        "${completeDir}/slskd".d = {
          user = "root";
          group = "media";
          mode = "2775";
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

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      sops.secrets."slskd/env" = { };

      containers.slskd = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.3";

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
          "/media/music" = {
            mountPoint = "/media/music:idmap";
            hostPath = musicDir;
            isReadOnly = true;
          };
          "/downloads/incomplete" = {
            mountPoint = "/downloads/incomplete:idmap";
            hostPath = "${incompleteDir}/slskd";
            isReadOnly = false;
          };
          "/downloads/complete" = {
            mountPoint = "/downloads/complete:idmap";
            hostPath = "${completeDir}/slskd";
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

              environmentFile = "/run/credentials/@system/slskd-env";

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
              allowedTCPPorts = ports.tcp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

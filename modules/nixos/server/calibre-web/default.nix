{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web =
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
          8083
        ];
        udp = [ ];
      };
    in
    {
      services.nginx.virtualHosts = {
        "calibre-web.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.5:8083";
            recommendedProxySettings = true;
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      containers.calibre-web = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.5";

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
          "/library" = {
            mountPoint = "/library:idmap";
            hostPath = "/srv/media/tank/Books/calibre-library";
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

            services.calibre-web = {
              enable = true;
              group = "media";

              listen = {
                ip = "0.0.0.0";
                port = 8083;
              };

              options = {
                calibreLibrary = "/library";
                enableBookUploading = true;
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

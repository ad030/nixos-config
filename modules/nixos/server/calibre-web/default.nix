{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web =
    let
      mediaGid = 3333;
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
        allowedTCPPorts = [ 8083 ];
      };

      containers.calibre-web = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.5";

        privateUsers = "pick";

        forwardPorts = [
          {
            hostPort = 8083;
            protocol = "tcp";
          }
        ];

        # no id map option yet, workaround
        # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
        bindMounts = {
          "/library" = {
            hostPath = "/srv/media/tank/Books/calibre-library:idmap";
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
              allowedTCPPorts = [ 8083 ];
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

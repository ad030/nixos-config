{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.navidrome =
    { pkgs, lib, ... }:
    let
      mediaGid = 3333;

      ports = {
        tcp = [
          4533 # web ui
        ];
        udp = [ ];
      };
    in
    {
      services.nginx.virtualHosts = {
        "navidrome.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.9:4533";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      containers.navidrome = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.9";

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
          "/media/music" = {
            mountPoint = "/media/music:idmap";
            hostPath = "/srv/media/tank/Music";
            isReadOnly = true;
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

            services.navidrome = {
              enable = true;
              group = "media";

              settings = {
                Port = 4533;

                Address = "0.0.0.0";
                MusicFolder = "/media/music";
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

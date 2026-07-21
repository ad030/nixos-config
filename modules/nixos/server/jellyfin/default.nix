{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin =
    { pkgs, lib, ... }:
    let
      mediaGid = 3333;

      ports = {
        tcp = [
          8096 # web ui
        ];
        udp = [ ];
      };
    in
    {
      services.nginx.virtualHosts = {
        "jellyfin.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.2:8096";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      containers.jellyfin = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.2";

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
          "/media/movies" = {
            mountPoint = "/media/movies:idmap";
            hostPath = "/srv/media/tank/Movies";
            isReadOnly = false;
          };
          "/media/shows" = {
            mountPoint = "/media/shows:idmap";
            hostPath = "/srv/media/tank/Shows";
            isReadOnly = false;
          };
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

            services.jellyfin = {
              enable = true;
              group = "media";
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

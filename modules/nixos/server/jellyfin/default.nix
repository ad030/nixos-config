{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin =
    { pkgs, lib, ... }:
    let
      inherit (self.lib.server) mkMediaUser;
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/jellyfin".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "0750";
        };
        "/srv/jellyfin/cache".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "0750";
        };
        "/srv/jellyfin/data".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "0750";
        };
        "/srv/jellyfin/config".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "0750";
        };
      };

      users = mkMediaUser {
        name = "jellyfin";
        uid = 3002;
      };

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
        allowedTCPPorts = [
          8096
        ];
      };

      containers.jellyfin = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.2";

        privateUsers = false; # use host uid and gid

        forwardPorts = [
          {
            hostPort = 8096;
            protocol = "tcp";
          }
          # {
          #   hostPort = 7359;
          #   protocol = "udp";
          # }
        ];

        bindMounts = {
          "/srv/jellyfin" = {
            hostPath = "/srv/jellyfin";
            isReadOnly = false;
          };
          "/media/movies" = {
            hostPath = "/srv/media/tank/Movies";
            isReadOnly = false;
          };
          "/media/shows" = {
            hostPath = "/srv/media/tank/Shows";
            isReadOnly = false;
          };
          "/media/music" = {
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
            services.jellyfin = {
              enable = true;
              user = "jellyfin";
              group = "jellyfin";

              cacheDir = "/srv/jellyfin/cache";
              dataDir = "/srv/jellyfin/data";
              configDir = "/srv/jellyfin/config";

              openFirewall = false;
            };

            networking.firewall = {
              allowedTCPPorts = [
                8096 # web ui
              ];
              # allowedUDPPorts = [
              #   7359 # auto detect jellyfin servers on network
              # ];
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

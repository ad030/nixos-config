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
      serviceUser = mkMediaUser {
        name = "jellyfin";
        uid = 3002;
      };
    in
    {
      systemd.tmpfiles.settings = {
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
        "/srv/jellyfin/data/config".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "0750";
        };
      };

      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "jellyfin.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.2:8096";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };

      containers.jellyfin = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.2";

        forwardPorts = [
          # {
          #   hostPort = 8096;
          #   protocol = "tcp";
          # }
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
        };

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            users = serviceUser.users;

            services.jellyfin = {
              enable = true;
              user = "jellyfin";
              group = "jellyfin";

              cacheDir = "/srv/jellyfin/cache";
              dataDir = "/srv/jellyfin/data";
              configDir = "/srv/jellyfin/data/config";

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

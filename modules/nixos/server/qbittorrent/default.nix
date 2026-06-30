{ self, inputs, ... }:
{
  flake.modules.nixos.qbittorrent =
    { pkgs, lib, ... }:
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "qbittorrent";
        uid = 3006;
      };
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/qbittorrent".d = {
          user = "qbittorrent";
          group = "qbittorrent";
          mode = "0750";
        };
      };

      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "qbittorrent.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.7:8090";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };

      containers.qbittorrent = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.7";

        forwardPorts = [
          {
            hostPort = 6881; # torrenting port
            protocol = "tcp";
          }
          {
            hostPort = 6881; # torrenting port
            protocol = "udp";
          }
          # {
          #   hostPort = 8090; # webui port
          #   protocol = "tcp";
          # }
        ];

        bindMounts = {
          "/srv/qbittorrent" = {
            hostPath = "/srv/qbittorrent";
            isReadOnly = false;
          };
          "/srv/downloads/incomplete" = {
            hostPath = "/srv/downloads/qbittorrent";
            isReadOnly = false;
          };
          "/srv/downloads/complete" = {
            hostPath = "/srv/media/tank/Downloads/qbittorrent";
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

            services.qbittorrent = {
              enable = true;
              package = pkgs.qbittorrent-nox;

              user = "qbittorrent";
              group = "qbittorrent";

              openFirewall = true;
              torrentingPort = 6881;
              webuiPort = 8090;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

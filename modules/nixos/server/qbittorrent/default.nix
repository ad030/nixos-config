{ self, inputs, ... }:
{
  flake.modules.nixos.qbittorrent =
    { pkgs, lib, ... }:
    let
      inherit (self.modules.nixos.serverLib) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "qbittorrent";
        uid = 3007;
      };
    in
    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "qbittorrent.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.7:8090";
            recommendedProxySettings = true;
          };
        };
      };

      containers.qbittorrent = {
        autoStart = true;

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
          {
            hostPort = 8090; # webui port
            protocol = "tcp";
          }
        ];

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
              group = "media";

              openFirewall = true;
              torrentingPort = 6881;
              webuiPort = 8090;
            };
          };
      };

    };
}

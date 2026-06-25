{ self, inputs, ... }:
{
  flake.modules.nixos.adguardhome =
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "adguardhome";
        uid = 3004;
      };
    in
    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "adguard.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.4:8096";
            recommendedProxySettings = true;
          };
        };
      };

      containers.adguardhome = {
        autoStart = true;

        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.4";

        forwardPorts = [
          {
            hostPort = 53;
            protocol = "tcp";
          }
          {
            hostPort = 443;
            protocol = "tcp";
          }
          {
            hostPort = 8080;
            containerPort = 80;
            protocol = "tcp";
          }
          {
            hostPort = 3000;
            protocol = "tcp";
          }
          {
            hostPort = 53;
            protocol = "udp";
          }
          {
            hostPort = 443;
            protocol = "udp";
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
            services.adguardhome = {
              enable = true;
            };

            networking.firewall = {
              allowedTCPPorts = [
                53 # dns
                80 # http
                443 # https
                3000 # admin panel
              ];
              allowedUDPPorts = [
                53
                443
              ];
            };
          };
      };

    };
}

{ self, inputs, ... }:
{
  flake.modules.nixos.freshrss =
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "freshrss";
        uid = 3006;
      };
    in

    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "freshrss.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.4:8096";
            recommendedProxySettings = true;
          };
        };
      };

      containers.freshrss = {
        autoStart = true;

        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.6";

        forwardPorts = [
          {
            hostPort = 8090;
            protocol = "tcp";
          }
          {
            hostPort = 6881;
            protocol = "tcp";
          }
          {
            hostPort = 6881;
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
            services.freshrss = {
              enable = true;
              webserver = "nginx";
            };

            networking.firewall = {
              allowedTCPPorts = [
                8090
                6881
              ];
              allowedUDPPorts = [
                6881
              ];
            };
          };
      };

    };
}

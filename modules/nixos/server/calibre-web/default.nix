{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web =
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "calibre-web";
        uid = 3005;
      };
    in
    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "calibre-web.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.5:8096";
            recommendedProxySettings = true;
          };
        };
      };

      containers.calibre-web = {
        autoStart = true;

        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.5";

        forwardPorts = [
          {
            hostPort = 8083;
            protocol = "tcp";
          }
          {
            hostPort = 8083;
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

            services.calibre-web = {
              enable = true;
            };

            networking.firewall = {
              allowedTCPPorts = [ 8083 ];
              allowedUDPPorts = [ 8083 ];
            };
          };
      };

    };
}

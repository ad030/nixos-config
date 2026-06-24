{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web =

    {

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

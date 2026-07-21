{ self, inputs, ... }:
{
  flake.modules.nixos.technitium =
    { config, lib, ... }:
    let
      TCPPorts = [
        53 # dns
        5380 # web ui
        53443 # web ui https
      ];
      UDPPorts = [
        53 # dns
      ];
    in
    {
      networking.firewall = {
        allowedTCPPorts = TCPPorts;
        allowedUDPPorts = UDPPorts;
      };

      services.nginx.virtualHosts = {
        "technitium.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.10:3000";
            recommendedProxySettings = true;
          };
        };
      };

      containers.adguardhome = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.10";

        privateUsers = "pick";

        forwardPorts = [
          {
            hostPort = 53;
            protocol = "tcp";
          }
          {
            hostPort = 53;
            protocol = "udp";
          }
          {
            hostPort = 5380;
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
            services.technitium-dns-server = {
              enable = true;

              openFirewall = false;
            };

            networking.firewall = {
              allowedTCPPorts = TCPPorts;
              allowedUDPPorts = UDPPorts;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved = {
              enable = true;

              # needs to be set in order for technitium to access port 53
              settings.Resolve.DNSStubListener = "no";
            };

            system.stateVersion = "26.05";
          };
      };
    };

}

{ self, inputs, ... }:
{
  flake.modules.nixos.technitium =
    { config, lib, ... }:
    let
      ports = {
        tcp = [
          53 # dns
          5380 # web ui
          53443 # web ui https
        ];
        udp = [
          53 # dns
        ];
      };
    in
    {
      networking.firewall = {
        allowedTCPPorts = ports.tcp;
        allowedUDPPorts = ports.udp;
      };

      services.nginx.virtualHosts = {
        "technitium.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.10:5380";
            recommendedProxySettings = true;
          };
        };
      };

      containers.technitium = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.10";

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

            systemd.services.technitium-dns-server.serviceConfig = {
              LogsDirectory = "technitium";
            };

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
              allowedUDPPorts = ports.udp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved = {
              enable = true;

              # needs to be set in order to access port 53
              settings.Resolve.DNSStubListener = "no";
            };

            system.stateVersion = "26.05";
          };
      };
    };

}

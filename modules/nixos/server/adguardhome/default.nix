{ self, inputs, ... }:
{
  flake.modules.nixos.adguardhome =
    { config, lib, ... }:
    let
      ports = {
        tcp = [
          53 # dns
          3000 # web ui
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
        "adguard.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.4:3000";
            recommendedProxySettings = true;
          };
        };
      };

      containers.adguardhome = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.4";

        privateUsers = "pick";

        # forwardPorts =
        #   (map (p: {
        #     hostPort = p;
        #     protocol = "tcp";
        #   }) ports.tcp)
        #   ++ (map (p: {
        #     hostPort = p;
        #     protocol = "udp";
        #   }) ports.udp);

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
            services.adguardhome = {
              enable = true;

              host = "0.0.0.0";
              port = 3000;

              mutableSettings = true;

              settings = {
                users = [
                  {
                    name = "admin";
                    # hashed password here because i'm too stupid to use sops-nix for this
                    password = "$2b$05$xAEJhRzoPgnSfmOKCgAP0OjgORZvKaSyTgEkCKUGOxTMOtfTJ0edC";
                  }
                ];
                filtering = {
                  protection_enabled = true;
                  filtering_enabled = true;
                  rewrites = [
                    {
                      domain = "*.home.lan";
                      answer = "192.168.8.201";
                      enabled = true;
                    }
                    {
                      domain = "home.lan";
                      answer = "192.168.8.201";
                      enabled = true;
                    }
                  ];
                };

              };

            };

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
              allowedUDPPorts = ports.udp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved = {
              enable = true;

              # needs to be set in order for adguard home to access port 53
              settings.Resolve.DNSStubListener = "no";
            };

            system.stateVersion = "26.05";
          };
      };
    };

}

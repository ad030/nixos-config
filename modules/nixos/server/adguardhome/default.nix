{ self, inputs, ... }:
{
  flake.modules.nixos.adguardhome =
    { config, lib, ... }:
    {
      networking.firewall = {
        allowedTCPPorts = [
          53
          3000
          8080
        ];
      };

      services.nginx.virtualHosts = {
        "adguard.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.4:80";
            recommendedProxySettings = true;
          };
        };
      };

      containers.adguardhome = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.4";

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
            hostPort = 443;
            protocol = "tcp";
          }
          {
            hostPort = 443;
            protocol = "udp";
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
        ];

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

              settings = {
                users = [
                  {
                    name = "admin";
                    password = "$2b$05$xAEJhRzoPgnSfmOKCgAP0OjgORZvKaSyTgEkCKUGOxTMOtfTJ0edC";
                  }
                ];
              };

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

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved = {
              enable = true;
              settings.Resolve = {
                DNSStubListener = "no";
              };
            };

            system.stateVersion = "26.05";
          };
      };
    };

}

{ self, inputs, ... }:
{
  flake.modules.nixos.adguardhome =
    { config, lib, ... }:
    {
      systemd.tmpfiles.settings = {
        "/srv/adguard".d = {
          user = "adguardhome";
          group = "adguardhome";
          mode = "0750";
        };
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

        bindMounts = {
          "/var/lib/AdGuardHome" = {
            hostPath = "/srv/adguardhome";
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
            services.adguardhome = {
              enable = true;

              settings = {
                filtering = {
                  rewrites = [
                    {
                      domain = "*.home.lan";
                      answer = "192.168.8.201";
                    }
                    {
                      domain = "home.lan";
                      answer = "192.168.8.201";
                    }
                  ];
                };
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
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

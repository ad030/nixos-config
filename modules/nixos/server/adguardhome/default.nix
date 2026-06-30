{ self, inputs, ... }:
{
  flake.modules.nixos.adguardhome =
    { config, lib, ... }:
    let
      inherit (self.lib.server) mkServiceUser;
      serviceUser = mkServiceUser {
        name = "adguardhome";
        uid = 3004;
      };
    in
    {
      users = serviceUser.users;

      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/adguardhome".d = {
          user = "adguardhome";
          group = "adguardhome";
          mode = "0750";
        };
      };

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
            users = serviceUser.users;

            services.adguardhome = {
              enable = true;

              settings = {
                filtering = {
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

            systemd.services.adguardhome.serviceConfig = {
              DynamicUser = lib.mkForce false;
              ProtectSystem = lib.mkForce false;
              User = "adguardhome";
              Group = "adguardhome";
              StateDirectory = lib.mkForce "AdGuardHome";
              StateDirectoryMode = "0750";
              AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ]; # needed to bind port 53
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

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

      localAddr = "10.0.0.10";
      webPort = "5380";
    in
    {
      networking.firewall = {
        allowedTCPPorts = ports.tcp;
        allowedUDPPorts = ports.udp;
      };

      services.nginx.virtualHosts = {
        "technitium.home.lan" = {
          locations."/" = {
            proxyPass = "http://${localAddr}:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      containers.technitium = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = localAddr;

        privateUsers = "pick";

        forwardPorts =
          map (p: {
            hostPort = p;
            protocol = "tcp";
          }) ports.tcp
          ++ map (p: {
            hostPort = p;
            protocol = "udp";
          }) ports.udp;

        config =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            services.technitium-dns-server = {
              enable = true;

              openFirewall = false;
            };

            # they messed up the hardening and technitium can't even write to its own log file
            # https://discourse.nixos.org/t/technitium-dns-fails-with-access-denied-at-var-lib/64672/4
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

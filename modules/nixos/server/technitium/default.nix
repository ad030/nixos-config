{ self, inputs, ... }:
{
  flake.modules.nixos.technitium =
    { config, lib, ... }:
    let
      localAddr = "127.0.0.1";
      webPort = "5380";
    in
    {
      networking.firewall = {
        allowedTCPPorts = [
          53
          5380
          53443
        ];
        allowedUDPPorts = [
          53
        ];
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

      services.technitium-dns-server = {
        enable = true;

        openFirewall = false;
      };

      # they messed up the hardening and technitium can't even write to its own log file
      # https://discourse.nixos.org/t/technitium-dns-fails-with-access-denied-at-var-lib/64672/4
      systemd.services.technitium-dns-server.serviceConfig = {
        LogsDirectory = "technitium";
      };
    };

}

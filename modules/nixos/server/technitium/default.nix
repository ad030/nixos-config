{ self, inputs, ... }:
{
  flake.modules.nixos.technitium =
    { config, lib, ... }:
    let
      localAddr = "127.0.0.1";
      webPort = "5380";
    in
    {
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

      virtualisation.oci-containers.containers = {
        technitium = {
          image = "docker.io/technitium/dns-server:15.5.1";
          hostname = "technitium";
          ports = [
            "53:53/tcp"
            "53:53/udp"
            "127.0.0.1:5380:5380/tcp"
            "127.0.0.1:53443:53443/tcp"
          ];
          volumes = [ "/srv/config/technitium:/etc/dns" ];
        };
      };

      services.resolved = {
        # needs to be set in order to access port 53
        settings.Resolve.DNSStubListener = "no";
      };
    };
}

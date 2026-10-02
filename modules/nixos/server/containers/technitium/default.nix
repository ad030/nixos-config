{ self, inputs, ... }:
let
  serviceName = "technitium";
  uid = 2030;
  webPort = "5380";
in
{
  flake.modules.nixos."containers-${serviceName}" =
    { config, lib, ... }:
    {
      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      # home-manager.users.${serviceName}.imports = [
      #   self.modules.homeManager."containers-${serviceName}"
      # ];

      services.nginx.virtualHosts = {
        "technitium.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      virtualisation.oci-containers.containers = {
        technitium = {
          image = "docker.io/technitium/dns-server:15.5.1@sha256:b8efe03a5e3bdc6e9d2baff3f6e70c382c7f98afa2a7ca66f318d4b58a8d5944";
          hostname = "technitium";
          ports = [
            "53:53/tcp"
            "53:53/udp"
            "127.0.0.1:5380:5380/tcp"
            "127.0.0.1:53443:53443/tcp"
          ];
          volumes = [
            "/srv/config/technitium:/etc/dns"
          ];

          ## Technitium bitches and complains if it doesn't have root access so whatever you can have it
          # user = "${toString config.users.users.technitium.uid}:${toString config.users.groups.technitium.gid}";
          # extraOptions = [
          #   "--sysctl=net.ipv4.ip_unprivileged_port_start=53"
          #   "--cap-drop=ALL"
          #   "--security-opt=no-new-privileges"
          # ];
        };
      };

      services.resolved = {
        # needs to be set in order to access port 53
        settings.Resolve.DNSStubListener = "no";
      };
    };
}

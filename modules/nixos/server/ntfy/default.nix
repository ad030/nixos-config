{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.ntfy =
    { pkgs, lib, ... }:
    let
      ports = {
        tcp = [
          8082 # web ui
        ];
        udp = [ ];
      };
    in
    {
      services.nginx.virtualHosts = {
        "ntfy.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.12:8082";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      containers.ntfy = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.12";

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
            pkgs,
            lib,
            ...
          }:
          {
            services.ntfy-sh = {
              enable = true;

              settings = {
                listen-http = ":8082";
                base-url = "https://ntfy.home.lan";
                behind-proxy = true;
              };
            };

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

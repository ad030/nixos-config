{
  self,
  inputs,
  config,
  ...
}@top:
let
  domain = "4384381.xyz";
in
{
  flake.modules.nixos.landing-page =
    {
      config,
      lib,
      ...
    }:
    let
      auth = top.config.flake.lib.nginx-tinyauth;
    in
    {
      environment.etc = {
        "www/index.html" = {
          text = builtins.readFile ./index.html;
        };
      };

      networking.firewall = {
        allowedTCPPorts = [
          80
          443
          8080
        ];
      };

      services.nginx.virtualHosts = {
        ${domain} = {
          default = true;

          locations."/".return = "301 https://www.${domain}$request_uri";

          forceSSL = true;
          useACMEHost = domain;
          # sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          # sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };

        "www.${domain}" = {
          locations = {
            "/" = {
              index = "index.html";
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          root = "/etc/www";

          listen = [
            {
              addr = "0.0.0.0";
              port = 80;
            }
            {
              addr = "0.0.0.0";
              port = 443;
              ssl = true;
            }
          ];

          forceSSL = true;
          useACMEHost = domain;
          # sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          # sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };
    };
}

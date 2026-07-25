{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.landing-page =
    {
      config,
      lib,
      ...
    }:
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
        "home.lan" = {
          default = true;

          locations."/".index = "index.html";

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
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };
    };
}

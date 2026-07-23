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

      services.nginx.virtualHosts = {
        "home.lan" = {
          default = true;

          locations."/".index = "index.html";
          root = "/etc/www";

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/_wildcard.home.lan.pem";
          sslCertificateKey = "/etc/nginx/ssl/_wildcard.home.lan-key.pem";
        };
      };

    };
}

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
    let
      protect = ''
        auth_request /tinyauth;
             auth_request_set $tinyauth_location $upstream_http_x_tinyauth_location;
             error_page 401 403 =302 $tinyauth_location;
      '';
      tinyauthLocation = {
        proxyPass = "http://127.0.0.1:3000/api/auth/nginx";
        extraConfig = ''
          internal;
          proxy_pass_request_body off;
          proxy_set_header Content-Length "";
          proxy_set_header x-forwarded-proto $scheme;
          proxy_set_header x-forwarded-host $http_host;
          proxy_set_header x-forwarded-uri $request_uri;
        '';
      };
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
        "home.lan" = {
          default = true;

          locations."/".return = "301 https://www.home.lan$request_uri";

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };

        "www.home.lan" = {
          locations = {
            "/" = {
              index = "index.html";
              extraConfig = protect;
            };
            "/tinyauth" = tinyauthLocation;
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
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };
    };
}

{
  self,
  ...
}:
let
  domainName = "4384381.xyz";
in
{
  flake.modules.nixos.domain-certs =
    {
      config,
      ...
    }:
    {
      # environment.etc = {
      #   "nginx/ssl/homelab-domain.pem" = {
      #     source = "/root/home.lan+1.pem";
      #     mode = "0444";
      #   };
      #   "nginx/ssl/homelab-domain-key.pem" = {
      #     source = "/root/home.lan+1-key.pem";
      #     mode = "0400";
      #     user = "nginx";
      #   };
      # };

      sops.secrets."porkbun/api_key" = {
        sopsFile = "${self}/secrets/api-keys.yaml";
      };
      sops.secrets."porkbun/secret_api_key" = {
        sopsFile = "${self}/secrets/api-keys.yaml";
      };

      sops.templates."acme-porkbun-keys.env".content = ''
        PORKBUN_API_KEY=${config.sops.placeholder."porkbun/api_key"}
        PORKBUN_SECRET_API_KEY=${config.sops.placeholder."porkbun/secret_api_key"}
      '';

      security.acme = {
        acceptTerms = true;
        defaults = {
          dnsResolver = "1.1.1.1:53";
          email = "darwinism_bagel013@simplelogin.com";
        };
        certs = {
          ${domainName} = {
            dnsProvider = "porkbun";
            group = config.services.nginx.group;
            environmentFile = config.sops.templates."acme-porkbun-keys.env".path;
            extraDomainNames = [
              "*.${domainName}"
            ];
          };

          # subdomains under this should not be exposed to internet
          "home.${domainName}" = {
            dnsProvider = "porkbun";
            group = config.services.nginx.group;
            environmentFile = config.sops.templates."acme-porkbun-keys.env".path;
            extraDomainNames = [
              "*.home.${domainName}"
            ];
          };
        };
      };
    };
}

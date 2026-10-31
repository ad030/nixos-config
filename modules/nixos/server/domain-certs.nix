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
      environment.etc = {
        "nginx/ssl/homelab-domain.pem" = {
          source = "/root/home.lan+1.pem";
          mode = "0444";
        };
        "nginx/ssl/homelab-domain-key.pem" = {
          source = "/root/home.lan+1-key.pem";
          mode = "0400";
          user = "nginx";
        };
      };

      sops.secrets."acme/porkbun" = { };

      security.acme = {
        acceptTerms = true;
        defaults.email = "darwinism_bagel013@simplelogin.com";
        certs.${domainName} = {
          dnsProvider = "porkbun";
          group = config.services.nginx.group;
          environmentFile = config.sops.secrets."acme/porkbun".path;
          extraDomainNames = [
            "*.${domainName}"
          ];
        };
      };
    };
}

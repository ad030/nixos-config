{
  self,
  ...
}:
{
  flake.modules.nixos.domain-certs = {
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
  };
}

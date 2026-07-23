{
  self,
  ...
}:
{
  flake.modules.nixos.domain-certs = {
    environment.etc = {
      "nginx/ssl/_wildcard.home.lan.pem" = {
        source = "/root/_wildcard.home.lan.pem";
        mode = "0444";
      };
      "nginx/ssl/_wildcard.home.lan-key.pem" = {
        source = "/root/_wildcard.home.lan-key.pem";
        mode = "0400";
        user = "nginx";
      };
    };
  };
}

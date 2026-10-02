{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-kiwix-serve =
    { config, lib, ... }:
    let
      webPort = "8084";

      directories = {
        zimFiles = "/srv/media/tank/zim_files";
      };
    in
    {
      services.nginx.virtualHosts = {
        "kiwix.home.lan" = {
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
        kiwix-serve = {
          image = "ghcr.io/kiwix/kiwix-serve:3.8.2@sha256:e478554a9920412eeb5ce1d73f24e4b28445ebed233187cdd03c623c32be46a5";
          hostname = "kiwix-serve";
          ports = [
            "127.0.0.1:8084:8084/tcp"
          ];
          volumes = [
            "${directories.zimFiles}:/data:ro"
          ];
          cmd = [
            "*.zim"
            "devdocs/*.zim"
            "stackexchange/*.zim"
            "wikipedia/*.zim"
            "wikibooks/*.zim"
            "wiktionary/*.zim"
            "libretexts/*.zim"
          ];
          environment = {
            PORT = "8084";
          };
        };
      };
    };
}

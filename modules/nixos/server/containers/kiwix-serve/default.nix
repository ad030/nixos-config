{
  self,
  inputs,
  ...
}:
let
  serviceName = "kiwix-serve";
  uid = 2015;
  webPort = "8084";

  directories = {
    zimFiles = "/srv/media/tank/zim_files";
  };
in
{
  flake.modules.nixos."containers-${serviceName}" =
    { config, lib, ... }:
    {
      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

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
    };

  flake.modules.homeManager."containers-${serviceName}" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.username = serviceName;
      home.homeDirectory = "/home/${serviceName}";
      home.stateVersion = "26.05";

      # generate data and cache directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };
      xdg.cacheFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          kiwix-serve = {
            image = "ghcr.io/kiwix/kiwix-serve:3.8.2@sha256:e478554a9920412eeb5ce1d73f24e4b28445ebed233187cdd03c623c32be46a5";
            ports = [
              "127.0.0.1:8084:8084/tcp"
            ];
            volumes = [
              "${directories.zimFiles}:/data:ro"
            ];
            exec = lib.concatStringsSep " " [
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
    };

}

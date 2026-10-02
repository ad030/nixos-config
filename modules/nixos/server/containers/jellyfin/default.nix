{
  self,
  inputs,
  ...
}:
let
  serviceName = "jellyfin";
  uid = 2002;

  directories = {
    movies = "/srv/media/tank/Movies";
    shows = "/srv/media/tank/Shows";
  };

  webPort = "8096";
in
{
  flake.modules.nixos.containers-jellyfin =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
          extraGroups = [
            "media"
            "render"
            "video"
          ];
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      services.nginx.virtualHosts = {
        "jellyfin.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      hardware.graphics.enable = true;

      # systemd.tmpfiles.settings."jellyfin-config" = {
      #   ${directories.config}.d = {
      #     user = serviceName;
      #     group = serviceName;
      #     mode = "0750";
      #   };
      #   ${directories.cache}.d = {
      #     user = serviceName;
      #     group = serviceName;
      #     mode = "0750";
      #   };
      # };
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

      xdg.dataFile."${serviceName}/.empty".text = "";
      xdg.cacheFile."${serviceName}/.empty".text = "";

      services.podman = {
        enable = true;
        containers = {
          jellyfin = {
            image = "docker.io/jellyfin/jellyfin:12.1@sha256:78d3ea1207d1322471fcac39a614f004f2ccf7e878f95ab2977d752f07e4dd7e";
            ports = [
              "127.0.0.1:8096:8096/tcp"
            ];
            volumes = [
              "${directories.movies}:/media/movies:ro"
              "${directories.shows}:/media/shows:ro"
              "${config.xdg.cacheHome}/${serviceName}:/cache:rw"
              "${config.xdg.dataHome}/${serviceName}:/config:rw"
            ];
            devices = [ "/dev/dri/renderD128:/dev/dri/renderD128" ];
            extraPodmanArgs = [ "--group-add=keep-groups" ];
          };
        };
      };
    };
}

{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "jellyfin";
  uid = 2002;

  image = "docker.io/jellyfin/jellyfin:12.1@sha256:78d3ea1207d1322471fcac39a614f004f2ccf7e878f95ab2977d752f07e4dd7e";

  url = "jellyfin.home.lan";
  webPort = "8096";

  directories = {
    movies = "/srv/media/tank/Movies";
    shows = "/srv/media/tank/Shows";
  };
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with top.config.flake.modules.nixos; [
        containers
      ];

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
        ${url} = {
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

      networking.firewall = {
        allowedTCPPorts = [ 8096 ];
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

      # generate xdg directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          ${serviceName} = {
            inherit image;
            ports = [
              "8096:8096/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/config:rw"
              "jellyfin-cache:/cache:rw"

              "${directories.movies}:/media/movies:ro"
              "${directories.shows}:/media/shows:ro"
            ];
            devices = [ "/dev/dri/renderD128:/dev/dri/renderD128" ];
            extraPodmanArgs = [ "--group-add=keep-groups" ];
            autoStart = true;
          };
        };
      };
    };
}

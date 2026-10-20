{
  self,
  inputs,
  ...
}:
let
  serviceName = "calibre-web-automated";
  directories = {
    library = "/srv/media/tank/Books/calibre-library";
    ingest = "/srv/media/tank/Books/ingest";
  };
  webPort = "8083";
  uid = 2003;

  image = "docker.io/crocodilestick/calibre-web-automated:v4.0.8@sha256:5e00373854247750cc3e4479b492ae09293ff5e06ed10177f226634d97888679";
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
      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
          extraGroups = [
            "media"
          ];
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      services.nginx.virtualHosts = {
        "calibre.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      systemd.tmpfiles.settings."calibre-web-automated-config" = {
        ${directories.ingest}.d = {
          user = serviceName;
          group = "media";
          mode = "0777";
        };
      };
    };

  flake.modules.homeManager."containers-${serviceName}" =
    {
      config,
      lib,
      osConfig,
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
          calibre-web-automated = {
            inherit image;
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/config"
              "${directories.library}:/calibre-library"
              "${directories.ingest}:/cwa-book-ingest"
            ];
            ports = [
              "127.0.0.1:8083:8083/tcp"
            ];
            environment = {
              PUID = uid;
              PGID = osConfig.users.groups.media.gid;
              TZ = "America/New_York";
              CWA_PORT_OVERRIDE = "8083";
            };
            autoStart = true;
          };
        };
      };
    };
}

{
  self,
  inputs,
  ...
}:
let
  serviceName = "navidrome";
  directories = {
    music = "/srv/media/tank/Music";
  };

  uid = 2006;

  webPort = "4533";
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
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      services.nginx.virtualHosts = {
        "navidrome.home.lan" = {
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

      # systemd.tmpfiles.settings."navidrome-config" = {
      #   "${directories.data}".d = {
      #     user = username;
      #     group = username;
      #     mode = "0700";
      #   };
      # };
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
          navidrome = {
            image = "docker.io/deluan/navidrome:0.64.2@sha256:38dc2727bfcfd5ede290f8ada114fc90368146f265ae4701ddddbcbe2a44ee52";
            ports = [
              "127.0.0.1:4533:4533/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/data"
              "${directories.music}:/music:ro"
            ];
            environment = {
              ND_BASEURL = "http://navidrome.home.lan";
            };
          };
        };
      };
    };
}

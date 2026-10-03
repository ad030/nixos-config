{
  self,
  inputs,
  ...
}:
let
  # directories = {
  #   data = "/srv/config/freshrss/data";
  #   extensions = "/srv/config/freshrss/extensions";
  # };
  serviceName = "freshrss";

  uid = 2005;

  webPort = "8085";
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      lib,
      pkgs,
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
      home-manager.users.${serviceName} = self.modules.homeManager."containers-${serviceName}";

      services.nginx.virtualHosts = {
        "freshrss.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      sops.secrets."freshrss/env/ADMIN_PASSWORD" = { };
      sops.secrets."freshrss/env/ADMIN_API_PASSWORD" = { };

      sops.templates."freshrss.env" = {
        owner = serviceName;
        content = ''
          FRESHRSS_USER=--user admin --password ${
            config.sops.placeholder."freshrss/env/ADMIN_PASSWORD"
          } --api-password ${config.sops.placeholder."freshrss/env/ADMIN_API_PASSWORD"} --language en
        '';
      };

      # networking.firewall.allowedTCPPorts = [ 8085 ];
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
      xdg.dataFile."${serviceName}-extensions/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          freshrss = {
            image = "docker.io/freshrss/freshrss:1.30.0@sha256:258b8edfc8a76a61f60d2d6a14d8f8d12495d78abf38646a2137612dfa264a21";
            ports = [
              "127.0.0.1:8085:80/tcp"
              # "8085:80/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/var/www/FreshRSS/data"
              "${config.xdg.dataHome}/${serviceName}-extensions:/var/www/FreshRSS/extensions"
            ];
            environmentFile = [
              "${osConfig.sops.templates."freshrss.env".path}"
            ];
            environment = {
              TZ = "America/New_York";
              CRON_MIN = "1,31";
              # nix complains about multiline string here
              FRESHRSS_INSTALL = lib.concatStringsSep " " [
                "--api-enabled"
                "--base-url https://freshrss.home.lan"
                "--default-user admin"
                "--language en"
              ];
              TRUSTED_PROXY = "192.168.8.201";
            };
          };

        };
      };
    };
}

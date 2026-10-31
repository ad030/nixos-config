{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "freshrss";
  uid = 2005;

  registry = "docker.io";
  repo = "freshrss/freshrss";
  tag = "1.30.4";
  digest = "sha256:af44385229541bee24aa9148d0ff8f3b40e095373c63a2c0f74e09a27d3c59df";
  image = "${registry}/${repo}:${tag}@${digest}";

  domain = "4384381.xyz";
  subdomain = "freshrss.${domain}";
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
    let
      auth = top.config.flake.lib.nginx-tinyauth;
    in
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
          ];
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName} = self.modules.homeManager."containers-${serviceName}";

      services.nginx.virtualHosts = {
        ${subdomain} = {
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${webPort}";
              recommendedProxySettings = true;
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
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

      # generate xdg directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };
      xdg.dataFile."freshrss-extensions/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          ${serviceName} = {
            inherit image;
            ports = [
              "127.0.0.1:8085:80/tcp"
              # "8085:80/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/var/www/FreshRSS/data"
              "${config.xdg.dataHome}/freshrss-extensions:/var/www/FreshRSS/extensions"
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
                "--base-url https://${subdomain}"
                "--default-user admin"
                "--language en"
              ];
              TRUSTED_PROXY = "192.168.8.201";
            };
            autoStart = true;
          };

        };
      };
    };
}

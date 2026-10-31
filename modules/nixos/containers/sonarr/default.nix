{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "sonarr";
  uid = 2010;

  image = "lscr.io/linuxserver/sonarr:4.0.20@sha256:f247545d23ba8b233d6604575347e48a623fe6ad75dda02348bf81917f3b5c06";

  domain = "4384381.xyz";
  subdomain = "sonarr.${domain}";
  webPort = "8989";

  directories = {
    shows = "/srv/media/tank/Shows";
  };
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
          group = "media";
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      services.nginx.virtualHosts = {
        ${subdomain} = {
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${webPort}";
              recommendedProxySettings = true;
              proxyWebsockets = true;
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      sops.secrets."sonarr/env" = {
        owner = serviceName;
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
            environment = {
              PUID = "0";
              PGID = "0";
              TZ = "America/New_York";
            };
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/config"

              "${directories.shows}:/media/shows"
            ];
            ports = [
              "127.0.0.1:8989:8989/tcp"
            ];
            environmentFile = [
              "${osConfig.sops.secrets."sonarr/env".path}"
            ];
            extraPodmanArgs = [ "--group-add=keep-groups" ];
            autoStart = true;
          };
        };
      };
    };
}

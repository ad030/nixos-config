{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "radarr";
  uid = 2009;

  image = "lscr.io/linuxserver/radarr";
  tag = "6.4.4";
  digest = "sha256:adb6c09d6b729ea5e642c99cea35af72702ef476bf4763f153299ac5db9f0b4f";

  domain = "4384381.xyz";
  subdomain = "radarr.${domain}";
  webPort = "7878";

  directories = {
    movies = "/srv/media/tank/Movies";
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

      sops.secrets."radarr/env" = {
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
            image = "${image}:${tag}@${digest}";
            environment = {
              PUID = "0";
              PGID = "0";
              TZ = "America/New_York";
            };
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/config"

              "${directories.movies}:/media/movies"
            ];
            ports = [
              "127.0.0.1:7878:7878/tcp"
            ];
            environmentFile = [
              "${osConfig.sops.secrets."radarr/env".path}"
            ];
            extraPodmanArgs = [ "--group-add=keep-groups" ];
            autoStart = true;
          };
        };
      };
    };
}

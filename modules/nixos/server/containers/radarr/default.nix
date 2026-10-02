{
  self,
  inputs,
  ...
}:
let
  serviceName = "radarr";
  uid = 2009;

  directories = {
    movies = "/srv/media/tank/Movies";
  };

  webPort = "7878";
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
          group = "media";
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

      services.nginx.virtualHosts = {
        "radarr.home.lan" = {
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

      sops.secrets."radarr/env" = {
        owner = serviceName;
      };

      # containers.radarr = {
      #   autoStart = true;
      #
      #   privateNetwork = true;
      #   hostAddress = "10.0.0.1";
      #   localAddress = localAddr;
      #
      #   privateUsers = "pick";
      #
      #   forwardPorts =
      #     map (p: {
      #       hostPort = p;
      #       protocol = "tcp";
      #     }) ports.tcp
      #     ++ map (p: {
      #       hostPort = p;
      #       protocol = "udp";
      #     }) ports.udp;
      #
      #   # no id map option yet, workaround
      #   # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
      #   bindMounts = {
      #     "/media/movies" = {
      #       mountPoint = "/media/movies:idmap";
      #       hostPath = moviesDir;
      #       isReadOnly = false;
      #     };
      #     "/downloads/complete" = {
      #       mountPoint = "/downloads/complete:idmap";
      #       hostPath = "${completeDir}/radarr";
      #       isReadOnly = false;
      #     };
      #     "/downloads/incomplete" = {
      #       mountPoint = "/downloads/incomplete:idmap";
      #       hostPath = "${incompleteDir}/radarr";
      #       isReadOnly = false;
      #     };
      #   };
      #
      #   extraFlags = [
      #     "--load-credential=radarr-env:${config.sops.secrets."radarr/env".path}"
      #   ];
      #
      #   config =
      #     {
      #       config,
      #       pkgs,
      #       lib,
      #       ...
      #     }:
      #     {
      #       users.groups.media.gid = mediaGid;
      #
      #       services.radarr = {
      #         enable = true;
      #
      #         group = "media";
      #
      #         environmentFiles = [
      #           "/run/credentials/@system/radarr-env"
      #         ];
      #
      #         settings = {
      #           server.port = 7878;
      #         };
      #       };
      #
      #       networking.firewall = {
      #         allowedTCPPorts = ports.tcp;
      #       };
      #
      #       networking.useHostResolvConf = lib.mkForce false;
      #       services.resolved.enable = true;
      #
      #       system.stateVersion = "26.05";
      #     };
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
          radarr = {
            image = "lscr.io/linuxserver/radarr:6.4.4@sha256:adb6c09d6b729ea5e642c99cea35af72702ef476bf4763f153299ac5db9f0b4f";
            environment = {
              PUID = "0";
              PGID = "0";
              TZ = "America/New_York";
            };
            volumes = [
              "${directories.movies}:/media/movies"
              "${config.xdg.dataHome}/${serviceName}:/config"
            ];
            ports = [
              "127.0.0.1:7878:7878/tcp"
            ];
            environmentFile = [
              "${osConfig.sops.secrets."radarr/env".path}"
            ];
            extraPodmanArgs = [ "--group-add=keep-groups" ];
          };
        };
      };
    };
}

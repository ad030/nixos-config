{
  self,
  inputs,
  ...
}:
let
  serviceName = "sonarr";

  uid = 2010;

  directories = {
    shows = "/srv/media/tank/Shows";
  };

  webPort = "8989";
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
        "sonarr.home.lan" = {
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

      sops.secrets."sonarr/env" = {
        owner = serviceName;
      };

      # containers.sonarr = {
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
      #     "/media/shows" = {
      #       mountPoint = "/media/shows:idmap";
      #       hostPath = showsDir;
      #       isReadOnly = false;
      #     };
      #     "/downloads/complete" = {
      #       mountPoint = "/downloads:idmap";
      #       hostPath = "${completeDir}/sonarr";
      #       isReadOnly = false;
      #     };
      #     "/downloads/incomplete" = {
      #       mountPoint = "/downloads:idmap";
      #       hostPath = "${incompleteDir}/sonarr";
      #       isReadOnly = false;
      #     };
      #   };
      #
      #   extraFlags = [
      #     "--load-credential=sonarr-env:${config.sops.secrets."sonarr/env".path}"
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
      #       services.sonarr = {
      #         enable = true;
      #
      #         group = "media";
      #
      #         environmentFiles = [
      #           "/run/credentials/@system/sonarr-env"
      #         ];
      #
      #         settings = {
      #           server.port = 8989;
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
          sonarr = {
            image = "lscr.io/linuxserver/sonarr:4.0.20@sha256:f247545d23ba8b233d6604575347e48a623fe6ad75dda02348bf81917f3b5c06";
            environment = {
              PUID = "0";
              PGID = "0";
              TZ = "America/New_York";
            };
            volumes = [
              "${directories.shows}:/media/shows"
              "${config.xdg.dataHome}/${serviceName}:/config"
            ];
            ports = [
              "127.0.0.1:8989:8989/tcp"
            ];
            environmentFile = [
              "${osConfig.sops.secrets."sonarr/env".path}"
            ];
            extraPodmanArgs = [ "--group-add=keep-groups" ];
          };
        };
      };
    };
}

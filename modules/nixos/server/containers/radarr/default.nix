{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-radarr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      username = "radarr";

      ids = {
        group = {
          media = 3333;
        };
        user = {
          ${username} = 2009;
        };
      };

      ports = {
        tcp = [
          7878 # web ui
        ];
        udp = [ ];
      };

      directories = {
        config = "/srv/config/radarr";
        movies = "/srv/media/tank/Movies";
      };

      webPort = "7878";
    in
    {
      virtualisation.oci-containers.containers = {
        radarr = {
          image = "lscr.io/linuxserver/radarr:6.4.4@sha256:adb6c09d6b729ea5e642c99cea35af72702ef476bf4763f153299ac5db9f0b4f";
          hostname = "radarr";
          environment = {
            PUID = "${toString config.users.users.${username}.uid}";
            PGID = "${toString config.users.groups.media.gid}";
            TZ = "America/New_York";
          };
          volumes = [
            "${directories.movies}:/movies"
            "${directories.config}:/config"
          ];
          ports = [
            "127.0.0.1:7878:7878/tcp"
          ];
          environmentFiles = [
            "${config.sops.secrets."radarr/env".path}"
          ];
          extraOptions = [
            "--group-add=${toString config.users.groups.media.gid}"
          ];
        };
      };

      systemd.tmpfiles.settings."radarr-config" = {
        ${directories.config}.d = {
          user = "radarr";
          group = "radarr";
          mode = "0700";
        };
      };

      users = {
        users.${username} = {
          uid = ids.user.${username};
          isNormalUser = true;
          group = username;
          extraGroups = [
            "media"
          ];
        };
        groups.${username}.gid = ids.user.${username};
      };

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

      sops.secrets."radarr/env" = { };

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
}

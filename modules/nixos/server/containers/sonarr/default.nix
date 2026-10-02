{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-sonarr =
    {
      config,
      lib,
      ...
    }:
    let
      username = "sonarr";

      ids = {
        group = {
          media = 3333;
        };
        user = {
          ${username} = 2010;
        };
      };

      ports = {
        tcp = [
          8989 # web ui
        ];
        udp = [ ];
      };

      directories = {
        shows = "/srv/media/tank/Shows";
        config = "/srv/config/sonarr";
      };

      webPort = "8989";
    in
    {
      virtualisation.oci-containers.containers = {
        sonarr = {
          image = "lscr.io/linuxserver/sonarr:4.0.20@sha256:f247545d23ba8b233d6604575347e48a623fe6ad75dda02348bf81917f3b5c06";
          hostname = "sonarr";
          environment = {
            PUID = "${toString config.users.users.${username}.uid}";
            PGID = "${toString config.users.groups.media.gid}";
            TZ = "America/New_York";
          };
          volumes = [
            "${directories.shows}:/shows"
            "${directories.config}:/config"
          ];
          ports = [
            "127.0.0.1:8989:8989/tcp"
          ];
          environmentFiles = [
            "${config.sops.secrets."sonarr/env".path}"
          ];
          extraOptions = [
            "--group-add=${toString config.users.groups.media.gid}"
          ];
        };
      };

      systemd.tmpfiles.settings."sonarr-config" = {
        ${directories.config}.d = {
          user = "sonarr";
          group = "sonarr";
          mode = "0700";
        };
      };

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

      sops.secrets."sonarr/env" = { };

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
}

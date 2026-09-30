{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web-automated =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "calibre";
      ids = {
        group = {
          media = 3333;
        };
        user = {
          ${username} = 2003;
        };
      };
      directories = {
        config = "/srv/config/calibre-web-automated";
        library = "/srv/media/tank/Books/calibre-library";
        ingest = "/srv/media/tank/Books/ingest";
      };
      webPort = "8083";
    in
    {
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

      users = {
        users.${username} = {
          uid = ids.user.${username};
          isNormalUser = true;
          group = username;
        };
        groups.${username}.gid = ids.user.${username};
      };

      systemd.tmpfiles.settings."calibre-web-automated-config" = {
        ${directories.config}.d = {
          user = username;
          group = "media";
          mode = "0750";
        };
        ${directories.ingest}.d = {
          user = username;
          group = "media";
          mode = "0777";
        };
      };

      virtualisation.oci-containers.containers = {
        calibre-web-automated = {
          image = "docker.io/crocodilestick/calibre-web-automated:v4.0.8@sha256:5e00373854247750cc3e4479b492ae09293ff5e06ed10177f226634d97888679";
          hostname = "calibre-web-automated";
          # user = "${toString config.users.users.calibre.uid}:${toString config.users.groups.calibre.gid}";
          volumes = [
            "${directories.config}:/config"
            "${directories.library}:/calibre-library"
            "${directories.ingest}:/cwa-book-ingest"
          ];
          ports = [
            "127.0.0.1:8083:8083/tcp"
          ];
          environment = {
            PUID = "${toString config.users.users.${username}.uid}";
            PGID = "${toString config.users.groups.${username}.gid}";
            TZ = "America/New_York";
            CWA_PORT_OVERRIDE = "8083";
          };
          extraOptions = [
            "--group-add=${toString ids.group.media}"
          ];
        };
      };

      # containers.calibre-web = {
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
      #     "/library" = {
      #       mountPoint = "/library:idmap";
      #       hostPath = "/srv/media/tank/Books/calibre-library";
      #       isReadOnly = false;
      #     };
      #   };
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
      #       services.calibre-web = {
      #         enable = true;
      #         group = "media";
      #
      #         listen = {
      #           ip = "0.0.0.0";
      #           port = 8083;
      #         };
      #
      #         options = {
      #           calibreLibrary = "/library";
      #           enableBookUploading = true;
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
      #       systemd.services.calibre-web.serviceConfig = {
      #         UMask = "0002";
      #       };
      #
      #       system.stateVersion = "26.05";
      #     };
      # };

    };
}

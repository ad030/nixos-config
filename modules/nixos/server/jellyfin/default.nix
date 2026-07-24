{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      mediaGid = config.users.groups.media.gid;
      renderGid = config.users.groups.render.gid;
      videoGid = config.users.groups.video.gid;

      ports = {
        tcp = [
          8096 # web ui
        ];
        udp = [ ];
      };
    in
    {
      services.nginx.virtualHosts = {
        "jellyfin.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.2:8096";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      # services.tailscale.serve.services = {
      #   jellyfin = {
      #     advertised = true;
      #     endpoints = {
      #       "tcp:8096" = "http://10.0.0.2:8096";
      #     };
      #   };
      # };

      # services.udev.extraRules = ''
      #   SUBSYSTEM=="drm", KERNEL=="renderD128", MODE="0666"
      #   SUBSYSTEM=="drm", KERNEL=="card1", MODE="0666"
      # '';

      containers.jellyfin = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.2";

        privateUsers = "pick";
        # privateUsers = "no";

        forwardPorts =
          map (p: {
            hostPort = p;
            protocol = "tcp";
          }) ports.tcp
          ++ map (p: {
            hostPort = p;
            protocol = "udp";
          }) ports.udp;

        # no id map option yet, workaround
        # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
        bindMounts = {
          "/media/movies" = {
            mountPoint = "/media/movies:idmap";
            hostPath = "/srv/media/tank/Movies";
            isReadOnly = false;
          };
          "/media/shows" = {
            mountPoint = "/media/shows:idmap";
            hostPath = "/srv/media/tank/Shows";
            isReadOnly = false;
          };
          "/media/music" = {
            mountPoint = "/media/music:idmap";
            hostPath = "/srv/media/tank/Music";
            isReadOnly = true;
          };

          # "/media/movies" = {
          #   mountPoint = "/media/movies";
          #   hostPath = "/srv/media/tank/Movies";
          #   isReadOnly = false;
          # };
          # "/media/shows" = {
          #   mountPoint = "/media/shows";
          #   hostPath = "/srv/media/tank/Shows";
          #   isReadOnly = false;
          # };
          # "/media/music" = {
          #   mountPoint = "/media/music";
          #   hostPath = "/srv/media/tank/Music";
          #   isReadOnly = true;
          # };

          # pass igpu in for hardware acceleration
          "/dev/dri/renderD128" = {
            mountPoint = "/dev/dri/renderD128";
            hostPath = "/dev/dri/renderD128";
            isReadOnly = false;
          };
          # "/dev/dri/card1" = {
          #   mountPoint = "/dev/dri/card1";
          #   hostPath = "/dev/dri/card1";
          #   isReadOnly = false;
          # };
        };

        allowedDevices = [
          {
            modifier = "rw";
            node = "/dev/dri/renderD128";
          }
          # {
          #   modifier = "rw";
          #   node = "/dev/dri/card1";
          # }
        ];

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            users.groups.media.gid = mediaGid;
            users.groups.render.gid = renderGid;
            users.groups.video.gid = videoGid;

            users.users.jellyfin.extraGroups = [
              "render"
              "video"
            ];

            services.jellyfin = {
              enable = true;
              group = "media";
            };

            hardware.graphics.enable = true;

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

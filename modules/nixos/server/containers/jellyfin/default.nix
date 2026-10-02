{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-jellyfin =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      ids = {
        group = {
          media = config.users.groups.media.gid;
          render = config.users.groups.render.gid;
          video = config.users.groups.video.gid;
        };

        user = {
          ${username} = 2002;
        };
      };

      directories = {
        config = "/srv/config/jellyfin";
        cache = "/var/cache/jellyfin";
        movies = "/srv/media/tank/Movies";
        shows = "/srv/media/tank/Shows";
      };

      username = "jellyfin";
      webPort = "8096";
    in
    {
      services.nginx.virtualHosts = {
        "jellyfin.home.lan" = {
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

      hardware.graphics.enable = true;

      users = {
        users.${username} = {
          uid = ids.user.${username};
          isNormalUser = true;
          group = username;
        };
        groups.${username}.gid = ids.user.${username};
      };

      systemd.tmpfiles.settings."jellyfin-config" = {
        ${directories.config}.d = {
          user = username;
          group = username;
          mode = "0750";
        };
        ${directories.cache}.d = {
          user = username;
          group = username;
          mode = "0750";
        };
      };

      virtualisation.oci-containers.containers = {
        jellyfin = {
          image = "docker.io/jellyfin/jellyfin:12.1@sha256:78d3ea1207d1322471fcac39a614f004f2ccf7e878f95ab2977d752f07e4dd7e";
          hostname = "jellyfin";
          user = "${toString config.users.users.${username}.uid}:${
            toString config.users.groups.${username}.gid
          }";
          ports = [
            "127.0.0.1:8096:8096/tcp"
          ];
          volumes = [
            "${directories.movies}:/media/movies:ro"
            "${directories.shows}:/media/shows:ro"
            "${directories.cache}:/cache:rw"
            "${directories.config}:/config:rw"
          ];
          devices = [ "/dev/dri/renderD128:/dev/dri/renderD128" ];
          extraOptions = [
            "--group-add=${toString ids.group.render}"
            "--group-add=${toString ids.group.video}"
            "--group-add=${toString ids.group.media}"
            "--cap-drop=ALL"
            "--security-opt=no-new-privileges"
          ];
        };
      };
    };
}

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

      jellyfinUid = 2002;

      localAddr = "127.0.0.1";
      webPort = "8096";
    in
    {
      services.nginx.virtualHosts = {
        "jellyfin.home.lan" = {
          locations."/" = {
            proxyPass = "http://${localAddr}:${webPort}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      hardware.graphics.enable = true;

      users.groups.jellyfin.gid = jellyfinUid;
      users.users.jellyfin = {
        isSystemUser = true;
        uid = jellyfinUid;
        group = "jellyfin";
      };

      systemd.tmpfiles.settings."jellyfin-config" = {
        "/srv/config/jellyfin/config".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "755";
        };
        "/srv/config/jellyfin/cache".d = {
          user = "jellyfin";
          group = "jellyfin";
          mode = "755";
        };
      };

      virtualisation.oci-containers.containers = {
        jellyfin = {
          image = "docker.io/jellyfin/jellyfin:12.1";
          hostname = "jellyfin";
          user = "${toString config.users.users.jellyfin.uid}:${toString config.users.groups.jellyfin.gid}";
          ports = [
            "127.0.0.1:8096:8096/tcp"
          ];
          volumes = [
            "/srv/media/tank/Movies:/media/movies:ro"
            "/srv/media/tank/Shows:/media/shows:ro"
            "/srv/config/jellyfin/cache:/cache:rw"
            "/srv/config/jellyfin/config:/config:rw"
          ];
          devices = [ "/dev/dri/renderD128:/dev/dri/renderD128" ];
          extraOptions = [
            "--group-add=${toString renderGid}"
            "--group-add=${toString videoGid}"
            "--group-add=${toString mediaGid}"
          ];
        };
      };
    };
}

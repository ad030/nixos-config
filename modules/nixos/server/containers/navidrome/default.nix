{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.containers-navidrome =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      username = "navidrome";
      directories = {
        data = "/srv/config/navidrome";
        music = "/srv/media/tank/Music";
      };

      ids = {
        user = {
          ${username} = 2006;
        };
      };

      webPort = "4533";
    in
    {
      services.nginx.virtualHosts = {
        "navidrome.home.lan" = {
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

      systemd.tmpfiles.settings."navidrome-config" = {
        "${directories.data}".d = {
          user = username;
          group = username;
          mode = "0700";
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

      virtualisation.oci-containers.containers = {
        navidrome = {
          image = "docker.io/deluan/navidrome:0.64.2@sha256:38dc2727bfcfd5ede290f8ada114fc90368146f265ae4701ddddbcbe2a44ee52";
          hostname = "navidrome";
          user = "${toString config.users.users.${username}.uid}:${
            toString config.users.groups.${username}.gid
          }";
          ports = [
            "127.0.0.1:4533:4533/tcp"
          ];
          volumes = [
            "${directories.data}:/data"
            "${directories.music}:/music:ro"
          ];
          environment = {
            ND_BASEURL = "http://navidrome.home.lan";
          };
        };
      };
    };
}

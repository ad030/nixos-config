{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      mediaGid = 3333;
      ports = {
        tcp = [
          8083
        ];
        udp = [ ];
      };
      localAddr = "10.0.0.5";
      webPort = "8083";
    in
    {
      services.nginx.virtualHosts = {
        "calibre.home.lan" = {
          locations."/" = {
            proxyPass = "http://${localAddr}:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      containers.calibre-web = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = localAddr;

        privateUsers = "pick";

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
          "/library" = {
            mountPoint = "/library:idmap";
            hostPath = "/srv/media/tank/Books/calibre-library";
            isReadOnly = false;
          };
        };

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            users.groups.media.gid = mediaGid;

            services.calibre-web = {
              enable = true;
              group = "media";

              listen = {
                ip = "0.0.0.0";
                port = 8083;
              };

              options = {
                calibreLibrary = "/library";
                enableBookUploading = true;
              };
            };

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            systemd.services.calibre-web.serviceConfig = {
              UMask = "0002";
            };

            system.stateVersion = "26.05";
          };
      };

    };
}

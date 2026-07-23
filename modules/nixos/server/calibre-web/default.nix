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
    in
    {
      services.nginx.virtualHosts = {
        "calibre-web.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.5:8083";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/_wildcard.home.lan.pem";
          sslCertificateKey = "/etc/nginx/ssl/_wildcard.home.lan-key.pem";
        };
      };

      networking.firewall = {
        allowedTCPPorts = ports.tcp;
      };

      services.tailscale.serve.services = {
        calibre-web = {
          advertised = true;
          endpoints = {
            "tcp:8083" = "http://10.0.0.5:8083";
          };
        };
      };

      containers.calibre-web = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.5";

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

            system.stateVersion = "26.05";
          };
      };

    };
}

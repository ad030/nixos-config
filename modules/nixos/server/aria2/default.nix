{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.aria2 =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      mediaGid = 3333;

      downloadsDir = "/srv/media/tank/Downloads";

      localAddr = "10.0.0.18";
      webPort = "6800";
    in
    {
      systemd.tmpfiles.settings."media-downloads" = {
        "${downloadsDir}/aria2".d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
      };

      services.nginx.virtualHosts = {
        "aria2.home.lan" = {
          root = "${pkgs.ariang}/share/ariang";

          locations."/jsonrpc" = {
            proxyPass = "http://${localAddr}:${webPort}/jsonrpc";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      sops.secrets."aria2/rpc-token" = { };

      containers.aria2 = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = localAddr;

        privateUsers = "pick";

        # no id map option yet, workaround
        # https://github.com/NixOS/nixpkgs/issues/329530#issuecomment-2513815925
        bindMounts = {
          "/downloads/complete" = {
            mountPoint = "/downloads/complete:idmap";
            hostPath = "${downloadsDir}/aria2";
            isReadOnly = false;
          };
        };

        # pass sops secret into container using systemd loadcredential
        # https://github.com/Mic92/sops-nix/issues/514#issuecomment-2036359239
        extraFlags = [
          "--load-credential=aria2-rpc-token:${config.sops.secrets."aria2/rpc-token".path}"
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

            services.aria2 = {
              enable = true;

              openPorts = true;

              rpcSecretFile = "/run/credentials/@system/aria2-rpc-token";

              serviceUMask = "0002";
              downloadDirPermission = "2775";

              settings = {
                dir = "/downloads/complete";
                enable-rpc = true;
                rpc-listen-all = true;
                disable-ipv6 = true;

                rpc-listen-port = 6800;

                listen-port = [
                  {
                    from = 6882;
                    to = 6999;
                  }
                ];
              };
            };

            systemd.services.aria2.serviceConfig = {
              Group = lib.mkForce "media";
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

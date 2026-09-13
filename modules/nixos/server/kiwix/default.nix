{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.kiwix-serve =
    { config, lib, ... }:
    let
      localAddr = "10.0.0.19";
      webPort = "8084";

      zimFilesDir = "/srv/media/tank/zim_files";
    in
    {
      services.nginx.virtualHosts = {
        "kiwix.home.lan" = {
          locations."/" = {
            proxyPass = "http://${localAddr}:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      containers.kiwix-serve = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = localAddr;

        privateUsers = "pick";

        forwardPorts = [
          {
            hostPort = 8084;
            containerPort = 8084;
            protocol = "tcp";
          }
        ];

        bindMounts = {
          "/zim" = {
            mountPoint = "/zim";
            hostPath = zimFilesDir;
            isReadOnly = true;
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
            services.kiwix-serve = {
              enable = true;

              port = 8084;
              openFirewall = true;

              library = import ./_library.nix;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

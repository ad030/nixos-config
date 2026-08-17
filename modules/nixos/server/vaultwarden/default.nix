{ self, inputs, ... }:
{
  flake.modules.nixos.vaultwarden =
    { config, lib, ... }:
    let
      ports = {
        tcp = [
          8222
        ];
        udp = [
        ];
      };
    in
    {
      networking.firewall = {
        allowedTCPPorts = ports.tcp;
        allowedUDPPorts = ports.udp;
      };

      services.nginx.virtualHosts = {
        "vaultwarden.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.15:8222";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      sops.secrets."vaultwarden/env" = { };

      containers.vaultwarden = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.15";

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

        # pass sops secret into container using systemd loadcredential
        # https://github.com/Mic92/sops-nix/issues/514#issuecomment-2036359239
        extraFlags = [
          "--load-credential=vaultwarden-env:${config.sops.secrets."vaultwarden/env".path}"
        ];

        config =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            services.vaultwarden = {
              enable = true;

              # domain = "https://vaultwarden.home.lan";

              backupDir = "/srv/backups/vaultwarden";

              environmentFile = "/run/credentials/@system/vaultwarden-env";

              webVaultPackage = pkgs.vaultwarden.webvault;

              config = {
                ROCKET_ADDRESS = "0.0.0.0";
                ROCKET_PORT = 8222;
                ROCKET_LOG = "critical";
              };
            };

            networking.firewall = {
              allowedTCPPorts = ports.tcp;
              allowedUDPPorts = ports.udp;
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };
    };

}

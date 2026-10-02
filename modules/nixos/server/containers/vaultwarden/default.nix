{ self, inputs, ... }:
{
  flake.modules.nixos.containers-vaultwarden =
    { config, lib, ... }:
    let
      username = "vaultwarden";

      directories = {
        data = "/srv/config/vaultwarden";
      };

      ids = {
        user = {
          ${username} = 2008;
        };
      };

      webPort = "8222";
    in
    {
      virtualisation.oci-containers.containers = {
        vaultwarden = {
          image = "docker.io/vaultwarden/server:1.37.3@sha256:1587c45feaa479f1f5e8af3b00eded36bff77bcf1880cf8dbf0541706dd470e0";
          hostname = "vaultwarden";
          ports = [
            "127.0.0.1:8222:80/tcp"
          ];
          volumes = [
            "${directories.data}:/data"
          ];
          environment = {
            DOMAIN = "https://vaultwarden.home.lan";
            ROCKET_LOG = "critical";
          };
          environmentFiles = [
            "${config.sops.secrets."vaultwarden/env".path}"
          ];
        };
      };

      services.nginx.virtualHosts = {
        "vaultwarden.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      sops.secrets."vaultwarden/env" = { };

      systemd.tmpfiles.settings."vaultwarden-config" = {
        ${directories.data}.d = {
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

      # containers.vaultwarden = {
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
      #   # pass sops secret into container using systemd loadcredential
      #   # https://github.com/Mic92/sops-nix/issues/514#issuecomment-2036359239
      #   extraFlags = [
      #     "--load-credential=vaultwarden-env:${config.sops.secrets."vaultwarden/env".path}"
      #   ];
      #
      #   config =
      #     {
      #       config,
      #       lib,
      #       pkgs,
      #       ...
      #     }:
      #     {
      #       services.vaultwarden = {
      #         enable = true;
      #
      #         # domain = "https://vaultwarden.home.lan";
      #
      #         backupDir = "/srv/backups/vaultwarden";
      #
      #         environmentFile = "/run/credentials/@system/vaultwarden-env";
      #
      #         webVaultPackage = pkgs.vaultwarden.webvault;
      #
      #         config = {
      #           ROCKET_ADDRESS = "0.0.0.0";
      #           ROCKET_PORT = 8222;
      #           ROCKET_LOG = "critical";
      #         };
      #       };
      #
      #       networking.firewall = {
      #         allowedTCPPorts = ports.tcp;
      #         allowedUDPPorts = ports.udp;
      #       };
      #
      #       networking.useHostResolvConf = lib.mkForce false;
      #       services.resolved.enable = true;
      #
      #       system.stateVersion = "26.05";
      #     };
      # };
    };

}

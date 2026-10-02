{ self, inputs, ... }:
let
  serviceName = "vaultwarden";
  uid = 2008;
  webPort = "8222";
in
{
  flake.modules.nixos."containers-${serviceName}" =
    { config, lib, ... }:
    {
      # needed for setting up rootless podman containers
      users = {
        users.${serviceName} = {
          inherit uid;
          isNormalUser = true;
          linger = true;
          group = serviceName;
        };
        groups.${serviceName}.gid = uid;
      };
      nix.settings.allowed-users = [ serviceName ];
      home-manager.users.${serviceName}.imports = [
        self.modules.homeManager."containers-${serviceName}"
      ];

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

      sops.secrets."vaultwarden/env" = {
        owner = serviceName;
      };

      # systemd.tmpfiles.settings."vaultwarden-config" = {
      #   ${directories.data}.d = {
      #     user = username;
      #     group = username;
      #     mode = "0700";
      #   };
      # };

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

  flake.modules.homeManager."containers-${serviceName}" =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    {
      home.username = serviceName;
      home.homeDirectory = "/home/${serviceName}";
      home.stateVersion = "26.05";

      # generate data and cache directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };
      xdg.cacheFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          vaultwarden = {
            image = "docker.io/vaultwarden/server:1.37.3@sha256:1587c45feaa479f1f5e8af3b00eded36bff77bcf1880cf8dbf0541706dd470e0";
            ports = [
              "127.0.0.1:8222:80/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/data"
            ];
            environment = {
              DOMAIN = "https://vaultwarden.home.lan";
              ROCKET_LOG = "critical";
            };
            environmentFile = [
              "${osConfig.sops.secrets."vaultwarden/env".path}"
            ];
          };
        };
      };
    };
}

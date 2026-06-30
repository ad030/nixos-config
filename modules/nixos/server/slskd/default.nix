{
  self,
  inputs,
  ...
}:

{
  flake.modules.nixos.slskd =
    { config, ... }:
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "slskd";
        uid = 3003;
      };
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/slskd".d = {
          user = "slskd";
          group = "slskd";
          mode = "0750";
        };
      };

      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "slskd.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.3:5030";
            recommendedProxySettings = true;
          };
        };
      };

      sops.secrets.slskd_env = {
        owner = "slskd";
      };

      containers.slskd = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.3";

        forwardPorts = [
          # {
          #   hostPort = 5030; # http web ui
          #   protocol = "tcp";
          # }
          # {
          #   hostPort = 5031; # https web ui
          #   protocol = "tcp";
          # }
          {
            hostPort = 50300; # soulseek connections
            protocol = "tcp";
          }
        ];

        # pass env file into container
        bindMounts = {
          "/run/secrets/slskd_env" = {
            hostPath = config.sops.secrets.slskd_env.path;
            isReadOnly = true;
          };
          "/var/lib/slskd" = {
            hostPath = "/srv/slskd";
            isReadOnly = false;
          };
          "/srv/downloads/complete" = {
            hostPath = "/srv/media/tank/Downloads/slskd";
            isReadOnly = false;
          };
          "/srv/downloads/incomplete" = {
            hostPath = "/srv/downloads/slskd";
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
            users = serviceUser.users;

            services.slskd = {
              enable = true;

              user = "slskd";
              group = "slskd";
              environmentFile = "/run/secrets/slskd_env";

              openFirewall = true;
              settings = {
                web.port = 5030;
              };
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

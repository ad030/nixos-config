{ self, inputs, ... }:
{
  flake.modules.nixos.freshrss =
    { config, lib, ... }:
    let
      inherit (self.lib.server) mkServiceUser;
      serviceUser = mkServiceUser {
        name = "freshrss";
        uid = 3005;
      };
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/freshrss".d = {
          user = "freshrss";
          group = "freshrss";
          mode = "0750";
        };
      };

      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "freshrss.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.6:80";
            recommendedProxySettings = true;
          };
        };
      };

      sops.secrets."freshrss/password" = {
        owner = "freshrss";
      };

      containers.freshrss = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.6";

        bindMounts = {
          "/srv/freshrss" = {
            hostPath = "/srv/freshrss";
            isReadOnly = false;
          };
          "/run/secrets/freshrss-password" = {
            hostPath = config.sops.secrets."freshrss/password".path;
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
            users = serviceUser.users;

            services.freshrss = {
              enable = true;
              dataDir = "/srv/freshrss";

              baseUrl = "http://freshrss.home.lan";

              defaultUser = "dokja";
              passwordFile = "/run/secrets/freshrss-password";
            };

            networking.firewall = {
              allowedTCPPorts = [
                80
              ];
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

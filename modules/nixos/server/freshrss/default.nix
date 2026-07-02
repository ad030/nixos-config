{ self, inputs, ... }:
{
  flake.modules.nixos.freshrss =
    { config, lib, ... }:
    let
      inherit (self.lib.server) mkServiceUser;
    in
    {
      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/freshrss".d = {
          user = "freshrss";
          group = "freshrss";
          mode = "0750";
        };
      };

      users = mkServiceUser {
        name = "freshrss";
        uid = 3006;
      };

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

        privateUsers = false; # use host uid and gid

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

{ self, inputs, ... }:
{
  flake.modules.nixos.freshrss =
    { config, lib, ... }:
    {
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

        privateUsers = "pick";

        bindMounts = {
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

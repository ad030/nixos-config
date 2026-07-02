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

      sops.secrets."freshrss/password" = { };

      containers.freshrss = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.6";

        privateUsers = "pick";

        # pass in sops secrets into container using systemd loadcredentials
        # https://github.com/Mic92/sops-nix/issues/514#issuecomment-2036359239
        extraFlags = [
          "--load-credential=freshrss-password:${config.sops.secrets."freshrss/password".path}"
        ];

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
              passwordFile = "/run/credentials/freshrss-config.service/freshrss-password";
            };

            networking.firewall = {
              allowedTCPPorts = [
                80
              ];
            };

            # needed to pass sops secret into service
            systemd.services.freshrss-config.serviceConfig.LoadCredential =
              "freshrss-password:freshrss-password";

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

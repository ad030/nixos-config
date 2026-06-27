{ self, inputs, ... }:
{
  flake.modules.nixos.freshrss =
    { config, lib, ... }:
    let
      inherit (self.lib.server) mkServiceUser;
      serviceUser = mkServiceUser {
        name = "freshrss";
        uid = 3006;
      };
    in
    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "freshrss.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.6:80";
            recommendedProxySettings = true;
          };
        };
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

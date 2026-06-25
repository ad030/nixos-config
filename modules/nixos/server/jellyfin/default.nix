{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin =
    { pkgs, lib, ... }:
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "jellyfin";
        uid = 3002;
      };
    in
    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "jellyfin.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.2:8096";
            recommendedProxySettings = true;
          };
        };
      };

      containers.jellyfin = {
        autoStart = true;

        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.2";

        forwardPorts = [
          {
            hostPort = 8096;
            protocol = "tcp";
          }
          {
            hostPort = 7359;
            protocol = "udp";
          }
        ];

        config =
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            users = serviceUser.users;

            services.jellyfin = {
              enable = true;
              user = "jellyfin";
              group = "jellyfin";

              openFirewall = false;
            };

            networking.firewall = {
              allowedTCPPorts = [
                8096 # web ui
              ];
              allowedUDPPorts = [
                7359 # auto detect jellyfin servers on network
              ];
            };

          };
      };

    };
}

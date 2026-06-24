{ self, inputs, ... }:

{
  flake.modules.nixos.slskd =
    let
      inherit (self.modules.nixos.serverLib) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "slskd";
        gid = 3003;
      };
    in
    {
      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "slskd.home" = {
          locations."/" = {
            proxyPass = "http://10.0.0.3:5030";
            recommendedProxySettings = true;
          };
        };
      };

      containers.slskd = {
        autoStart = true;

        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.3";

        forwardPorts = [
          {
            hostPort = 5030; # http web ui
            protocol = "tcp";
          }
          {
            hostPort = 5031; # https web ui
            protocol = "tcp";
          }
          {
            hostPort = 50300; # soulseek connections
            protocol = "tcp";
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

            services.slskd = {
              enable = true;

              user = "slskd";
              group = "media";

              openFirewall = true;

              settings = {
                web.port = 5030;
              };
            };
          };
      };

    };
}

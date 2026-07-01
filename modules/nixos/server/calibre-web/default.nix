{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web =
    let
      inherit (self.lib.server) mkMediaUser;
      serviceUser = mkMediaUser {
        name = "calibre-web";
        uid = 3005;
      };
    in
    {

      systemd.tmpfiles.settings."homelab-dirs" = {
        "/srv/calibre-web".d = {
          user = "calibre-web";
          group = "calibre-web";
          mode = "0750";
        };
      };

      users = serviceUser.users;

      services.nginx.virtualHosts = {
        "calibre-web.home.lan" = {
          locations."/" = {
            proxyPass = "http://10.0.0.5:8083";
            recommendedProxySettings = true;
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = [ 8083 ];
      };

      containers.calibre-web = {
        autoStart = true;

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.5";

        forwardPorts = [
          {
            hostPort = 8083;
            protocol = "tcp";
          }
        ];

        bindMounts = {
          "/srv/calibre-web" = {
            hostPath = "/srv/calibre-web";
            isReadOnly = false;
          };
          "/library" = {
            hostPath = "/srv/media/tank/Books/calibre-library";
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
            services.calibre-web = {
              enable = true;

              dataDir = "/srv/calibre-web";
              user = "calibre-web";
              group = "calibre-web";

              listen = {
                ip = "0.0.0.0";
                port = 8083;
              };

              options = {
                calibreLibrary = "/library";
                enableBookUploading = true;
              };
            };

            networking.firewall = {
              allowedTCPPorts = [ 8083 ];
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;

            system.stateVersion = "26.05";
          };
      };

    };
}

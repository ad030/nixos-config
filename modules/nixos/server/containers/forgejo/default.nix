{
  self,
  inputs,
  ...
}:
let
  serviceName = "forgejo";
  webPort = "8094";
  uid = 2019;
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
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
        "forgejo.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      networking.firewall.allowedTCPPorts = [
        2222
      ];

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

      # generate data, cache, directories
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
          forgejo = {
            image = "codeberg.org/forgejo/forgejo:16.0.5-rootless@sha256:5effb7305584aca479b29fde6f9631a6dbe86ae798ae02eeea33a3666f0c0bf8";
            user = "1000:1000";
            userNS = "keep-id:uid=1000,gid=1000";
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/var/lib/gitea"
              "/etc/localtime:/etc/localtime:ro"
            ];
            ports = [
              "127.0.0.1:${webPort}:3000/tcp"
              "2222:2222/tcp"
            ];
            environment = {
              USER_UID = 1000;
              USER_GID = 1000;
            };
            autoStart = true;
          };
        };
      };
    };
}

{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "vaultwarden";
  uid = 2008;

  image = "docker.io/vaultwarden/server:1.37.3@sha256:1587c45feaa479f1f5e8af3b00eded36bff77bcf1880cf8dbf0541706dd470e0";

  domain = "4384381.xyz";
  subdomain = "vaultwarden.${domain}";
  webPort = "8222";
in
{
  flake.modules.nixos."containers-${serviceName}" =
    { config, lib, ... }:
    let
      auth = top.config.flake.lib.nginx-tinyauth;
    in
    {
      imports = with top.config.flake.modules.nixos; [
        containers
      ];

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
        ${subdomain} = {
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${webPort}";
              recommendedProxySettings = true;
              proxyWebsockets = true;
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      sops.secrets."vaultwarden/env" = {
        owner = serviceName;
      };
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

      # generate xdg directories
      xdg.dataFile."${serviceName}/.empty" = {
        text = "";
        force = true;
      };

      services.podman = {
        enable = true;
        containers = {
          ${serviceName} = {
            inherit image;
            ports = [
              "127.0.0.1:8222:80/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/data"
            ];
            environment = {
              DOMAIN = "https://vaultwarden.home.lan";
              ROCKET_LOG = "critical";
            };
            environmentFile = [
              "${osConfig.sops.secrets."vaultwarden/env".path}"
            ];
            autoStart = true;
          };
        };
      };
    };
}

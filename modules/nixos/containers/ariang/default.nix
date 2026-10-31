{
  self,
  config,
  inputs,
  ...
}@top:
let
  serviceName = "ariang";
  uid = 2020;

  image = "docker.io/wahyd4/aria2-ui:6.4.0@sha256:d0896842c21e0a1fad9e9e4b8af6af258151fe79d9a82f7cff91f56285691d1a";

  domain = "4384381.xyz";
  subdomain = "aria2.${domain}";
  webPort = "8098";

  directories = {
    downloads = "/srv/media/tank/Downloads/aria2";
  };
in
{
  flake.modules.nixos."containers-${serviceName}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
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
            "/jsonrpc" = {
              proxyPass = "http://127.0.0.1:6800/jsonrpc";
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

      sops.secrets."ariang/env" = {
        owner = serviceName;
      };

      systemd.tmpfiles.settings."${serviceName}-config" = {
        "${directories.downloads}".d = {
          user = serviceName;
          group = "media";
          mode = "2775";
        };
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
            user = "0:0";
            userNS = "keep-id";
            ports = [
              "127.0.0.1:${webPort}:80"
              "127.0.0.1:6800:6800"
            ];
            volumes = [
              "${directories.downloads}:/data"
              "ariang-cache:/app/.cache"
            ];
            environment = {
              PUID = toString osConfig.users.users.${serviceName}.uid;
              PGID = toString osConfig.users.groups.${serviceName}.gid;
              DOMAIN = "http://${subdomain}";
              ARIA2_EXTERNAL_PORT = "443";
            };
            environmentFile = [
              # contains RPC_SECRET, ARIA2_USER, ARIA2_PASSWORD
              "${osConfig.sops.secrets."ariang/env".path}"
            ];
            autoStart = true;
          };
        };
      };
    };
}

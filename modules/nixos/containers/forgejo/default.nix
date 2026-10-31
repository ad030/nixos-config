{
  self,
  inputs,
  config,
  ...
}@top:
let
  serviceName = "forgejo";
  uid = 2019;

  image = "codeberg.org/forgejo/forgejo:16.0.5-rootless@sha256:5effb7305584aca479b29fde6f9631a6dbe86ae798ae02eeea33a3666f0c0bf8";

  domain = "4384381.xyz";
  subdomain = "forgejo.${domain}";
  webPort = "8094";
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
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
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

{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "ntfy";
  uid = 2004;

  # https://hub.docker.com/r/binwiederhier/ntfy
  image = "docker.io/binwiederhier/ntfy";
  tag = "v2.38.0";
  digest = "sha256:771309aecfce18d8fe2bfb8069994ddd6be6ca6ccdd7badace3d791a0045ff0d";

  domain = "home.4384381.xyz";
  subdomain = "ntfy.${domain}";
  webPort = "8082";
  backend = "http://127.0.0.1:${webPort}";
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
              proxyPass = backend;
              recommendedProxySettings = true;
              proxyWebsockets = true;
            };
          };

          forceSSL = true;
          useACMEHost = domain;
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
            image = "${image}:${tag}@${digest}";
            user = "${toString osConfig.users.users.${serviceName}.uid}:${
              toString osConfig.users.groups.${serviceName}.gid
            }";
            exec = "serve";
            ports = [
              "127.0.0.1:8082:8082/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/etc/ntfy"
              "ntfy-cache:/var/cache/ntfy"
            ];
            environment = {
              NTFY_BASE_URL = "http://${subdomain}";
              NTFY_LISTEN_HTTP = ":8082";
              NTFY_BEHIND_PROXY = "true";
            };
            autoStart = true;
          };
        };
      };
    };

}

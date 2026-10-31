{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "ntfy";
  uid = 2004;

  image = "docker.io/binwiederhier/ntfy";
  tag = "v2.35";
  digest = "sha256:6f0c9abab7b99a978d816611cc90dabb4849b81f60c53114e91cd07931085dc0";

  domain = "4384381.xyz";
  subdomain = "ntfy.${domain}";
  webPort = "8082";
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
            "/tinyauth" = auth.locationConfig;
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

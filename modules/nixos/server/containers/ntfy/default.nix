{
  self,
  inputs,
  ...
}:
let
  serviceName = "ntfy";
  uid = 2004;

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

      virtualisation.oci-containers.containers = {
      };

      services.nginx.virtualHosts = {
        "ntfy.home.lan" = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
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

      # generate data and cache directories
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
          ntfy = {
            image = "docker.io/binwiederhier/ntfy:v2.28@sha256:6ef4b819f722fccdc036af611c4774cfdc2de821ab74fdd48bbf4c9d6f8973da";
            user = "${toString osConfig.users.users.${serviceName}.uid}:${
              toString osConfig.users.groups.${serviceName}.gid
            }";
            exec = "serve";
            ports = [
              "127.0.0.1:8082:8082/tcp"
            ];
            volumes = [
              "${config.xdg.cacheHome}/${serviceName}:/var/cache/ntfy"
              "${config.xdg.dataHome}/${serviceName}:/etc/ntfy"
            ];
            environment = {
              NTFY_BASE_URL = "http://ntfy.home.lan";
              NTFY_LISTEN_HTTP = ":8082";
              NTFY_BEHIND_PROXY = "true";
            };
            autoStart = true;
          };
        };
      };
    };

}

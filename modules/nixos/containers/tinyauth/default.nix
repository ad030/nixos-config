{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "tinyauth";
  uid = 2050;

  image = "ghcr.io/tinyauthapp/tinyauth:v5.2.0@sha256:220aa235c76393a73fece831d7ba967b8698d3907fd8e3c4c952f699c7b142a5";

  domain = "4384381.xyz";
  subdomain = "tinyauth.${domain}";
  webPort = "3000";
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
          locations."/" = {
            proxyPass = "http://127.0.0.1:${webPort}";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };

          forceSSL = true;
          useACMEHost = domain;
          # sslCertificate = "/etc/nginx/ssl/homelab-domain.pem";
          # sslCertificateKey = "/etc/nginx/ssl/homelab-domain-key.pem";
        };
      };

      sops.secrets."tinyauth/env" = {
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
              "127.0.0.1:${webPort}:3000"
            ];
            volumes = [
            ];
            environment = {
              TINYAUTH_APPURL = "https://${subdomain}";
              TINYAUTH_AUTH_SECURECOOKIE = "true";
            };
            environmentFile = [
              "${osConfig.sops.secrets."tinyauth/env".path}"
            ];
            autoStart = true;
          };
        };
      };
    };

}

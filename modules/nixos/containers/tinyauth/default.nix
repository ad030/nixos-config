{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "tinyauth";
  uid = 2050;

  image = "ghcr.io/tinyauthapp/tinyauth";
  tag = "v5.2.0";
  digest = "sha256:220aa235c76393a73fece831d7ba967b8698d3907fd8e3c4c952f699c7b142a5";

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
        ${domain} = {
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
            image = "${image}:${tag}@${digest}";
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

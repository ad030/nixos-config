{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "navidrome";
  uid = 2006;

  # https://hub.docker.com/r/deluan/navidrome
  image = "docker.io/deluan/navidrome";
  tag = "0.64.2";
  digest = "sha256:38dc2727bfcfd5ede290f8ada114fc90368146f265ae4701ddddbcbe2a44ee52";

  domain = "home.4384381.xyz";
  subdomain = "navidrome.${domain}";
  backend = "http://127.0.0.1:${toString ports.web}";

  ports = {
    web = 4533;
  };

  directories = {
    music = "/srv/media/tank/Music";
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
      interfaces = {
        lan = builtins.attrNames config.networking.interfaces;
        wg = builtins.attrNames config.networking.wireguard.interfaces;
      };
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
              extraConfig = auth.appendProtect "";
            };
            "/tinyauth" = auth.locationConfig;

            # exempt from auth protection
            "/rest" = {
              proxyPass = backend;
              recommendedProxySettings = true;
            };
            "/auth" = {
              proxyPass = backend;
              recommendedProxySettings = true;
            };
            "/api" = {
              proxyPass = backend;
              recommendedProxySettings = true;
            };
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      networking.firewall.interfaces = lib.genAttrs (interfaces.lan ++ interfaces.wg) (_: {
        allowedTCPPorts = [
          ports.web
        ];
        allowedUDPPorts = [ ];
      });
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
              "${toString ports.web}:4533/tcp"
            ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/data"

              "${directories.music}:/music:ro"
            ];
            environment = {
              ND_BASEURL = "http://${subdomain}";
              ND_PORT = "4533";
            };
            autoStart = true;
          };
        };
      };
    };
}

{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "ddns-updater";
  uid = 2055;

  # https://hub.docker.com/r/qmcgaw/ddns-updater
  image = "docker.io/qmcgaw/ddns-updater"; # e.g. docker.io/slskd/slskd
  tag = "v2.10.0"; # e.g. 0.26.1
  digest = "sha256:3e2aa558946b5a293def4d73008fa4651c072b2c12932cecd02126fb23979831"; # sha256 hash

  domain = "home.4384381.xyz"; # base domain
  subdomain = "ddns.${domain}";
  webPort = "8000";
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
            };
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      systemd.tmpfiles.settings."${serviceName}-config" = { };

      sops.secrets."porkbun/api_key" = {
        sopsFile = "${self}/secrets/api-keys.yaml";
      };
      sops.secrets."porkbun/secret_api_key" = {
        sopsFile = "${self}/secrets/api-keys.yaml";
      };

      sops.templates."ddns-updater.json" = {
        owner = serviceName;
        mode = "0400";
        content = builtins.toJSON {
          settings = [
            {
              provider = "porkbun";
              domain = "vpn.4384381.xyz";
              api_key = config.sops.placeholder."porkbun/api_key";
              secret_api_key = config.sops.placeholder."porkbun/secret_api_key";
              ip_version = "ipv4";
              ipv6_suffix = "";
              ttl = 600;
            }
          ];
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
            ports = [
              "127.0.0.1:${webPort}:8000"
            ];
            user = "${toString osConfig.users.users.${serviceName}.uid}";
            userNS = "keep-id";
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:/updater/data" # service configuration
              "${osConfig.sops.templates."ddns-updater.json".path}:/updater/data/config.json:ro"
            ];
            environment = {
              DATADIR = "/updater/data";
              CONFIG_FILEPATH = "/updater/data/config.json";
              LISTENING_ADDRESS = ":8000";
            };
            environmentFile = [ ];
            autoStart = true;
          };
        };
      };
    };

}

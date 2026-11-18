{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "";
  uid = -1;

  # ADD LINK TO IMAGES PAGE HERE #
  image = ""; # e.g. docker.io/slskd/slskd
  tag = ""; # e.g. 0.26.1
  digest = ""; # sha256 hash

  domain = ""; # base domain
  subdomain = ".${domain}";
  backend = "http://127.0.0.1:${toString ports.web}";

  ports = {
    web = -1;
  };

  directories = { };
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
              # extraConfig = auth.appendProtect "";
            };
            # "/tinyauth" = auth.locationConfig;
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      systemd.tmpfiles.settings."${serviceName}-config" = { };

      # open ports to lan and wireguard interfaces
      networking.firewall = {
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
        interfaces = lib.genAttrs (interfaces.lan ++ interfaces.wg) (_: {
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        });
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
            ports = [ ];
            volumes = [
              "${config.xdg.dataHome}/${serviceName}:" # service configuration
            ];
            environment = { };
            environmentFile = [ ];
            autoStart = true;
          };
        };
      };
    };

}

{
  self,
  inputs,
  ...
}@top:
let
  serviceName = "llama-cpp";
  uid = 2060;

  # https://github.com/ggml-org/llama.cpp/pkgs/container/llama.cpp
  image = "ghcr.io/ggml-org/llama.cpp"; # e.g. docker.io/slskd/slskd
  tag = "server"; # e.g. 0.26.1
  digest = "sha256:7751a6c0dc3d019c231d42678abbb0fac1a13a24c17c956109ed27533139f280"; # sha256 hash

  domain = "home.4384381.xyz"; # base domain
  subdomain = "llama.${domain}";
  webPort = "9931";
  backend = "http://127.0.0.1:${webPort}";

  directories = {
    models = "/srv/ai-models";
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
              proxyPass = backend;
              recommendedProxySettings = true;
            };
          };

          forceSSL = true;
          useACMEHost = domain;
        };
      };

      systemd.tmpfiles.settings."${serviceName}-config" = {
        "${directories.models}".d = {
          user = serviceName;
          group = serviceName;
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
            image = "${image}:${tag}@${digest}";
            ports = [
              "127.0.0.1:${webPort}:8080"
            ];
            volumes = [
              "${directories.models}:/models:ro"
            ];
            environment = {
              LLAMA_ARG_PORT = "8080";
              LLAMA_ARG_HOST = "0.0.0.0";
            };
            environmentFile = [ ];
            autoStart = true;
          };
        };
      };
    };

}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.jellyfin = { pkgs, lib, ... }: {
    containers.jellyfin = {
      autoStart = true;

      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.2";

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.jellyfin = {
            enable = true;
          };

        };
    };

    services.nginx.virtualHosts = {
      "jellyfin.home.srv" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
        };
      };
    };

  };
}

{ self, inputs, ... }:
{
  flake.modules.nixos.adguardhome = {
    containers.adguardhome = {
      autoStart = true;

      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.4";

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.adguardhome = {
            enable = true;
          };
        };
    };

  };
}

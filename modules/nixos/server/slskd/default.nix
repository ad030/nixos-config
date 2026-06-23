{ self, inputs, ... }:
{
  flake.modules.nixos.slskd = {
    containers.slskd = {
      autoStart = true;

      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.3";

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.slskd = {
            enable = true;
          };
        };
    };

  };
}

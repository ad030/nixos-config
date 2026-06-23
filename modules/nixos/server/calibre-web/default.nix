{ self, inputs, ... }:
{
  flake.modules.nixos.calibre-web = {
    containers.calibre-web = {
      autoStart = true;

      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.5";

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.calibre-web = {
            enable = true;
          };
        };
    };

  };
}

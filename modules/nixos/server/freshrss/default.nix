{ self, inputs, ... }:
{
  flake.modules.nixos.freshrss = {
    containers.freshrss = {
      autoStart = true;

      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.6";

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.freshrss = {
            enable = true;
            webserver = "nginx";
          };
        };
    };

  };
}

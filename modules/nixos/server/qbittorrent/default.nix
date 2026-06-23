{ self, inputs, ... }:
{
  flake.modules.nixos.qbittorrent = { pkgs, lib, ... }: {

    containers.qbittorrent = {
      autoStart = true;

      hostAddress = "10.0.0.1";
      localAddress = "10.0.0.7";

      config =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          services.qbittorrent = {
            enable = true;
            package = pkgs.qbittorrent-nox;
          };

          networking.firewall = {
            allowedTCPPorts = [
              6881 # torrenting port
              8090 # web ui port
            ];
            allowedUDPPorts = [
              6881
              8090
            ];
          };
        };
    };

  };
}

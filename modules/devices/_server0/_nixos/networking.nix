{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    # Enable networking
    networkmanager.enable = true;

    firewall.enable = true;

    interfaces.wlp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.8.210";
          prefixLength = 24;
        }
      ];
    };
  };
}

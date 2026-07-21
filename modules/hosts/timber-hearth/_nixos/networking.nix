{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    hostId = "b4072d19";
    interfaces.wlp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.8.220";
          prefixLength = 24;
        }
      ];
    };
  };
}

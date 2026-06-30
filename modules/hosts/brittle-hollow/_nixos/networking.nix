{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    hostId = "5213c5fa";
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

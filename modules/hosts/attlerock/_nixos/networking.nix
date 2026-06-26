{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    interfaces.wlp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.8.201";
          prefixLength = 24;
        }
      ];
    };
  };
}

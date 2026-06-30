{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    interfaces.eno1 = {
      ipv4.addresses = [
        {
          address = "192.168.8.201";
          prefixLength = 24;
        }
      ];
    };
  };
}

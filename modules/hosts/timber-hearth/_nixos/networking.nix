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

    nameservers = [
      "10.100.0.1"
      # "192.168.8.201"
      # "100.93.96.79"
      "9.9.9.9"
      "1.1.1.1"
    ];
  };
}

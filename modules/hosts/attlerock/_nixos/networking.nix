{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    hostId = "4be7dc7a";
    defaultGateway = "192.168.8.1";

    interfaces.eno1 = {
      ipv4.addresses = [
        {
          address = "192.168.8.201";
          prefixLength = 24;
        }
      ];
    };

    nameservers = [
      "10.0.0.10"
      "9.9.9.9"
      "1.1.1.1"
    ];
  };
}

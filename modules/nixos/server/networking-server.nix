{
  flake.modules.nixos.networking-server = { lib, ... }: {
    networking = {
      nftables.enable = true;

      nat = {
        enable = true;
        # Use "ve-*" when using nftables instead of iptables
        internalInterfaces = [ "ve-*" ];
        externalInterface = lib.mkDefault "eno1";
        # Lazy IPv6 connectivity for the container
        enableIPv6 = true;
      };

      # create bridge interface
      # needed by some services to function properly
      # e.g. technitium
      bridges = {
        br0 = {
          interfaces = [ "eno1" ];
        };
      };

      interfaces.br0.useDHCP = true;
      interfaces.eno1.useDHCP = false;
    };
  };
}

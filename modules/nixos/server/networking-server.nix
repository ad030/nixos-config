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
    };
  };
}

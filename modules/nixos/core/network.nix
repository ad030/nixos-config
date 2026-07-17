{
  flake.modules.nixos.network =
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
        nftables.enable = true;
      };
    };
}

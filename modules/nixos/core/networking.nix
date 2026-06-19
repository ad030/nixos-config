{
  flake.modules.nixos.networking =
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
      };
    };
}

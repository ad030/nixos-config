{
  flake.modules.nixos.network =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
      ];
      networking = {
        # Enable networking
        networkmanager.enable = true;
        firewall.enable = true;
        nftables.enable = true;
      };
    };
}

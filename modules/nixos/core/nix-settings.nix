{
  flake.modules.nixos.nix-settings =
    {
      config,
      pkgs,
      ...
    }:
    {
      nix.settings = {
        experimental-features = [
          # enable nix flakes
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
      };

      # automatic garbage collection
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
}

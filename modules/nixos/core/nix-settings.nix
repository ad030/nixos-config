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
      };
    };
}

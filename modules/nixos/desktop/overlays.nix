# overlays for specific packages
{
  flake.modules.nixos.overlays-desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
      ];
    };
}

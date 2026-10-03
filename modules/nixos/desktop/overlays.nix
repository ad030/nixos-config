# overlays for specific packages
{
  self,
  inputs,
  ...
}:
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
        (final: prev: {
          inherit
            (import inputs.nixpkgs-zotero {
              inherit (prev.stdenv.hostPlatform) system;
              config.allowUnfree = true;
            })
            zotero
            ;
        })
      ];
    };
}

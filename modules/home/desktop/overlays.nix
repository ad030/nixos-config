# overlays for specific packages
{
  flake.modules.homeManager.desktop-pkgs-overlays =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          # zotero fails to build due to deprecated version of firefox esr
          # https://github.com/NixOS/nixpkgs/issues/568692
          zotero = prev.zotero.overrideAttrs (old: {
            version = "9.0.6";
            src = final.fetchFromGithub {
              owner = "zotero";
              repo = "zotero";
              revision = "7132587";
              hash = "";
            };
          });
        })
      ];
    };
}

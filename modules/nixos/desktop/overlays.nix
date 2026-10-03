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
        # zotero fails to build due to deprecated version of firefox esr
        # https://github.com/NixOS/nixpkgs/issues/568692
        (final: prev: {
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

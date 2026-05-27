{ pkgs, lib, ... }:
let
  theme = import ../../../themes/gruvbox.nix { inherit lib; };
in
{
  programs.fuzzel = {
    settings = {
      main = {
        terminal = "${pkgs.foot}/bin/foot";
        layer = "overlay";
        font = "MesloLGM Nerd Font:size=12";
      };

      colors = theme.fuzzel;

    };
  };
}

{ pkgs, lib, ... }:
let
  theme = import ../../../themes/gruvbox.nix { inherit lib; };
in
{
  programs = {
    foot = {
      enable = true;

      settings = {
        main = {
          # font = "Fira Code Mono:size=14";
          font = "Meslo LGM Nerd Font Mono:size=14";
        };

        colors-dark = theme.foot;

        mouse = {
          hide-when-typing = "yes";
        };

      };
    };
  };
}

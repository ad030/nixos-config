{ pkgs, ... }:
let
  theme = import ../colors/gruvbox-dark.nix;
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

        colors = {
          alpha = "0.80";
        };

        mouse = {
          hide-when-typing = "yes";
        };

      };
    };
  };
}

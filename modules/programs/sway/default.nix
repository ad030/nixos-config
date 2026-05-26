{ pkgs, config, lib, ... }:
let
  theme = import ../../../themes/gruvbox.nix { inherit lib; };
  wallpaper = "~/nixos/images/wallpapers/solar_system.png";
in
{
  home.packages = [ 
    pkgs.swaylock 
    pkgs.swayidle 
  ];

  wayland = {
    windowManager = {
        sway = {
          enable = true;

          checkConfig = false;

          wrapperFeatures.gtk = true;

          config = rec {
            modifier = "Mod4"; # super key
            terminal = "foot";
            menu = "rofi -modi \"window,drun,run\" -show drun";

            output = {
              "*" = {
                bg = "${wallpaper} fill";
              };
            };

            seat = {
              "*" = {
                xcursor_theme = "${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}";
              };
            };

            gaps = {
              smartGaps = true;
              smartBorders = "on";
              inner = 2;
              outer = 2;
            };

            bars = [
              { command = "waybar"; } # use waybar instead of swaybar
            ]; 

            window = {
              border = 1;
            };

            colors = theme.sway; 

            defaultWorkspace = "workspace number 1";

            focus.followMouse = false;

            fonts = {
              names = [ "MesloLGM Nerd Font Mono" ];
              size = 14.0;
            };

            keybindings = lib.mkOptionDefault {
              "${modifier}+Shift+r" = "reload";
            };

          }; # end config

        }; # end sway

      }; # end windowManager

    }; # end wayland

} # end nix file

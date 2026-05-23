{ pkgs, config, lib, ... }:
let
  theme = import ../colors/gruvbox-dark.nix;
  wallpaper = "~/nixos/modules/home-manager/images/wallpapers/solar_system.png";
in
{

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
              smartBorders = "off";
              inner = 2;
              outer = 2;
            };

            bars = [
              { command = "waybar"; } # use waybar instead of swaybar
            ]; 

            window = {
              border = 1;
            };

            colors = { 
              focused = {
                border = theme.fg0;
                background = theme.bg0;
                text = theme.fg0;
                indicator = theme.purple;
                childBorder = theme.fg0;
              };
              unfocused = {
                border = theme.fg4;
                background = theme.bg0;
                text = theme.bg4;
                indicator = theme.purple;
                childBorder = theme.bg4;
              };
              # same as unfocused
              focusedInactive = {
                border = theme.fg4;
                background = theme.bg0;
                text = theme.bg4;
                indicator = theme.purple;
                childBorder = theme.bg4;
              };
              urgent = {
                border = theme.red;
                background = theme.red;
                text = theme.bg0;
                indicator = theme.purple;
                childBorder = theme.red;
              };
              placeholder = {
                border = theme.green;
                background = theme.bg0;
                text = theme.fg0;
                indicator = theme.purple;
                childBorder = theme.green;
              };
            };

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

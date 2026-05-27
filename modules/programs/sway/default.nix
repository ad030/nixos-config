{
  pkgs,
  config,
  lib,
  ...
}:
let
  theme = import ../../../themes/gruvbox.nix { inherit lib; };
  wallpaper = "~/nixos/images/wallpapers/solar_system.png";
in
{
  home.packages = with pkgs; [
    swaylock
    swayidle
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
          # menu = "rofi -modi \"window,drun,run\" -show drun";
          # menu = "vicinae toggle";
          menu = "fuzzel";

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

            commands = [
              {
                command = "inhibit_idle fullscreen";
                criteria = {
                  class = ".*";
                  app_id = ".*";
                };
              }
            ];
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

  services.swayidle =
    let
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 240;
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 60 seconds' -t 5000";
        }
        {
          timeout = 300;
          command = lock;
        }
        {
          timeout = 310;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 360;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];

      events = {
        before-sleep = (display "off") + "; " + lock;
        lock = (display "off") + "; " + lock;
        after-resume = display "on";
        unlock = display "on";
      };

    }; # end services.swayidle

} # end nix file

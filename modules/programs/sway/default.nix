{
  flake.modules.homeManager.sway =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      theme = import ../../../themes/gruvbox.nix { inherit lib; };
      wallpaper = "~/nixos/images/wallpapers/solar_system.png";
      modifier = "Mod4";
    in
    {
      imports = [
        ./wl-screenshot.nix
      ];
      home.packages = with pkgs; [
        swaylock
        swayidle
      ];

      wayland = {
        windowManager = {
          sway = {
            systemd.enable = true;

            checkConfig = false;

            wrapperFeatures.gtk = true;

            config = {
              modifier = modifier; # super key
              terminal = "foot";
              # menu = "rofi -modi \"window,drun,run\" -show drun";
              menu = "fuzzel";

              startup = [
                {
                  command = "keepassxc";
                  always = true;
                }
              ];

              input = {
                "*" = {
                  xkb_layout = "us";
                  xkb_options = "terminate:ctrl_alt_bksp";
                };
              };

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
                  {
                    command = "move scratchpad && notify-send 'KeePassXC opened in scratchpad'";
                    criteria = {
                      app_id = "org.keepass.KeePassXC";
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
                "${modifier}+Shift+s" = "exec wl-screenshot";
                XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 4%-";
                XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +4%";
                XF86AudioMute = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                XF86AudioLowerVolume = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-";
                XF86AudioRaiseVolume = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%+";
                "${modifier}+minus" = "scratchpad show";
                "${modifier}+Shift+minus" = "move scratchpad";
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

    };
}

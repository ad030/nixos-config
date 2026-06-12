{ self, inputs, ... }:
{
  flake.modules.homeManager.sway =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      theme = self.themes.gruvbox-dark;
      # wallpaper = "~/nixos-config/images/wallpapers/solar_system.png";
      wallpaper = self.images.solar-system;
      modifier = "Mod4";
    in
    {
      imports = [
        self.modules.homeManager.wl-screenshot
      ];

      home.packages = with pkgs; [
        swaylock
        swayidle
      ];

      wayland = {
        windowManager = {
          sway = {
            enable = true;
            systemd.enable = true;

            checkConfig = false;

            wrapperFeatures.gtk = true;

            config = {
              modifier = modifier; # super key
              terminal = "foot";
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

              window = {
                border = 1;
                titlebar = false;
              };

              gaps = {
                smartGaps = true;
                smartBorders = "on";
                inner = 2;
                outer = 2;
              };

              bars = [
                { command = lib.getExe config.programs.waybar.package; } # use waybar instead of swaybar
              ];

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
                "${modifier}+XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 4%-";
                "${modifier}+XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +4%";
                "${modifier}+XF86AudioMute" =
                  "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                "${modifier}+XF86AudioLowerVolume" =
                  "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-";
                "${modifier}+XF86AudioRaiseVolume" =
                  "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%+";
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

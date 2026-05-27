{ pkgs, lib, ... }:
let
  theme = import ../../../themes/gruvbox.nix { inherit lib; };
in
{
  programs.waybar = {

    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 34;

        modules-left = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "backlight"
          "wireplumber"
          "network"
          "battery"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";

          # format-icons = {
          #   focused = "X";
          # };
        };

        clock = {
          format = "{:%a %Y-%m-%d %H:%M}";

          tooltip = true;
          tooltip-format = "<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "month";
            iso8601 = "true";
          };

          interval = 60;
          max-length = 25;
        };

        battery = {
          states = {
            full = 95;
            warning = 30;
            critical = 15;
          };

          format = "[{icon} {capacity}%]";
          format-charging = "[{icon} {capacity}%]";
          format-icons = {
            charging = "";
            default = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          max-length = 10;
        };

        cpu = {
          format = "[{icon} {usage}%]";
          format-icons = [ "" ];

          interval = 10;

          max-length = 10;
        };

        memory = {
          format = "[{icon} {percentage}%]";
          format-icons = [ "" ];

          interval = 30;

          max-length = 10;

        };

        pulseaudio = {
          format = "[{icon} {volume}%]";
          format-muted = "[{icon} Muted]";
          # format-source = "[{icon} {source_volume}]";
          # format-source-muted = "[{icon} Muted]";
          # tooltip-format = "{format_source}";

          format-icons = {
            source = "";
            source-muted = "";
            default = [ "" ];
          };

          tooltip = false;

          max-length = 10;
        };

        wireplumber = {
          format = "[{icon} {volume}%]";
          format-muted = "[{icon} Muted]";
          # format-source = "[ {source_volume}]";
          # format-source-muted = "[ Muted]";
          tooltip-format = " {source_volume}%";

          format-icons = [ "" ];

          tooltip = true;

          max-length = 10;
        };

        network = {
          format = "[{ifname}]";
          format-wifi = "[{icon} {signalStrength}%]";
          format-disconnected = "[{icon} No connection]";
          tooltip-format-wifi = "{essid}\n{ipaddr}";
          format-icons = {
            wifi = "";
            disconnected = "";
          };

          tooltip = true;

        };

        backlight = {
          format = "[{icon} {percent}%]";
          format-icons = [ "" ];

          tooltip = false;
        };

      }; # end main bar
    }; # end settings

    style = ''
      * {
        border-radius: 0;
        font-family: MesloLGM Nerd Font;
        font-size: 16px;
        background-color: ${theme.palette.dark1};
        color: ${theme.palette.light1};
      }

      button:hover {
        box-shadow: none;
        text-shadow: none;
        border-color: transparent;
        background: none;
        transition: none;
      }

      #workspaces button.focused {
        box-shadow: inset 0 -2px ${theme.palette.light1};
      }
    ''; # end style

  }; # end programs.waybar
} # end nix file

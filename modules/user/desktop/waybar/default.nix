{ pkgs, ... }:
let 
  colors = import ../../colors/gruvbox-dark.nix;
in
{
  home.packages = [ pkgs.waybar ];

  programs = {
    waybar = {

      enable = true;

      settings = {
        main = {
          layer = "top";
          position = "top";
          height = 34;

          modules-left = [ "sway/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "network" "backlight" "pulseaudio" "battery" ];

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
              default = ["" "" "" "" ""];
            };
            max-length = 25;
          };

          pulseaudio = {
            format = "[{icon} {volume}%]";
            format-muted = "[{icon} M]";
            format-icons = [ "" ];

            tooltip = false;
          };

          network = {
            format = "[{ifname}]";
            format-wifi = "[{icon} {signalStrength}%]";
            format-alt = "[{essid} {ipaddr}]";
            format-disconnected = "[{icon} No connection]";

            tooltip = false;

            format-icons = {
              wifi = "";
              disconnected = "";
            };
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
          background-color: ${colors.bg0};
          color: ${colors.fg0};
        }

        #workspaces button:hover {
          box-shadow: none;
          text-shadow: none;
          background: none;
          transition: none;
        }

        #workspaces button.focused {
          box-shadow: inset 0 -2px ${colors.fg0};
        }
      ''; # end style

    }; # end waybar 
  }; # end programs
} # end nix file

{
  flake.modules.homeManager.waybar =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      theme = import ../../../themes/gruvbox.nix { inherit lib; };
    in
    {
      services = {
        blueman-applet.enable = true;
        network-manager-applet.enable = true;
      };

      programs.waybar = {
        settings = {
          main = {
            layer = "top";
            position = "top";
            height = 34;

            modules-left = [
              "sway/workspaces"
              "sway/scratchpad"
            ];
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
              format = "[{index}]";
              disable-scroll = true;
              all-outputs = true;
            };

            "sway/scratchpad" = {
              format = "[{icon}:{count}]";
              format-empty = "[{icon}:{count}]";
              show-empty = true;
              format-icons = [ "S" ];
              tooltip = true;
              tooltip-format = "{app}: {title}";
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
            color: ${theme.palette.light1};
            font-size: 16px;
          }

          window#waybar {
            background-color: ${theme.palette.dark1};
            color: ${theme.palette.light1};
          }

          #clock,
          #battery,
          #cpu,
          #workspaces,
          #scratchpad,
          #memory,
          #backlight,
          #wireplumber,
          #network {
            background-color: ${theme.palette.dark1};
            color: ${theme.palette.light1};
            margin: 0 2px;
          }

          button:hover {
            box-shadow: none;
            text-shadow: none;
            border-color: transparent;
            background: none;
            transition: none;
          }

          #workspaces button {
            padding: 0 8px;
          }

          #workspaces button.focused {
            background-color: ${theme.palette.dark4};
            box-shadow: inset 0 -2px ${theme.palette.light1};
          }
        ''; # end style

      }; # end programs.waybar
    }; # end function
} # end file

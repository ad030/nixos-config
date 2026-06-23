{ self, inputs, ... }:
{
  flake.modules.homeManager.waybar =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {

      services = {
        blueman-applet.enable = true;
        network-manager-applet.enable = true;
      };

      programs.waybar = {
        enable = true;
        settings = {
          main = {
            layer = "top";
            position = "top";
            height = 40;

            modules-left = [
              "niri/workspaces"
              # "sway/workspaces"
            ];
            modules-right = [
              # "sway/scratchpad"
              # "mpris"
              "idle_inhibitor"
              "cpu"
              "memory"
              "backlight"
              "wireplumber"
              "network"
              "battery"
              "clock"
            ];

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
            };

            "sway/window" = {
              format = "{title}";
              max-length = 50;
            };

            "sway/workspaces" = {
              format = "{index}";
              disable-scroll = true;
              all-outputs = true;
            };

            "sway/scratchpad" = {
              format = "{icon}:{count}";
              format-empty = "";
              show-empty = false;
              format-icons = [ "S" ];
              tooltip = true;
              tooltip-format = "{app}: {title}";
            };

            "niri/workspaces" = {
              format = "{value}";
              all-outputs = false;
              disable-click = false;
            };

            clock = {
              format = "{:%Y-%m-%d %H:%M}";

              tooltip = true;
              tooltip-format = "{:%A, %B %e}";

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

              format = "{icon} {capacity}%";
              format-charging = "{icon} {capacity}%";
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
              format = "{icon} {usage}%";
              format-icons = [ "" ];

              interval = 10;

              max-length = 10;
            };

            memory = {
              format = "{icon} {percentage}%";
              format-icons = [ "" ];

              interval = 30;

              max-length = 10;

            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = "{icon} Muted";
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
              format = "{icon} {volume}%";
              format-muted = "{icon} Muted";
              # format-source = "[ {source_volume}]";
              # format-source-muted = "[ Muted]";
              tooltip-format = " {source_volume}%";

              format-icons = [ "" ];

              tooltip = true;

              max-length = 10;
            };

            network = {
              format = "{ifname}";
              format-wifi = "{icon} {signalStrength}%";
              format-disconnected = "{icon} No connection";
              tooltip-format-wifi = "{essid}\n{ipaddr}";
              format-icons = {
                wifi = "";
                disconnected = "";
              };

              tooltip = true;
            };

            backlight = {
              format = "{icon} {percent}%";
              format-icons = [ "" ];

              tooltip = false;
            };

            mpris = {
              format = "{artist} - {title} [{position}/{length}]";
            };

          }; # end main bar
        }; # end settings

      }; # end programs.waybar
    }; # end function
} # end file

# Gruvbox color palette by morhetz
{ self, inputs, ... }:
let
  lib = inputs.nixpkgs-stable.lib;
in
{
  flake.themes.gruvbox-dark =
    let
      palette = {
        dark0_hard = "#1d2021";
        dark0 = "#282828";
        dark0_soft = "#32302f";
        dark1 = "#3c3836";
        dark2 = "#504945";
        dark3 = "#665c54";
        dark4 = "#7c6f64";
        dark4_256 = "#7c6f64";

        gray_245 = "#928374";
        gray_244 = "#928374";

        light0_hard = "#f9f5d7";
        light0 = "#fbf1c7";
        light0_soft = "#f2e5bc";
        light1 = "#ebdbb2";
        light2 = "#d5c4a1";
        light3 = "#bdae93";
        light4 = "#a89984";
        light4_256 = "#a89984";

        bright_red = "#fb4934";
        bright_green = "#b8bb26";
        bright_yellow = "#fabd2f";
        bright_blue = "#83a598";
        bright_purple = "#d3869b";
        bright_aqua = "#8ec07c";
        bright_orange = "#fe8019";

        neutral_red = "#cc241d";
        neutral_green = "#98971a";
        neutral_yellow = "#d79921";
        neutral_blue = "#458588";
        neutral_purple = "#b16286";
        neutral_aqua = "#689d6a";
        neutral_orange = "#d65d0e";

        faded_red = "#9d0006";
        faded_green = "#79740e";
        faded_yellow = "#b57614";
        faded_blue = "#076678";
        faded_purple = "#8f3f71";
        faded_aqua = "#427b58";
        faded_orange = "#af3a03";
      };
      alpha = "1.00";
    in
    {
      inherit palette;

      sway = {
        focused = {
          border = palette.light1;
          background = palette.dark1;
          text = palette.light1;
          indicator = palette.neutral_purple;
          childBorder = palette.light0;
        };
        unfocused = {
          border = palette.light4;
          background = palette.dark1;
          text = palette.dark4;
          indicator = palette.neutral_purple;
          childBorder = palette.dark4;
        };

        # same as unfocused
        focusedInactive = {
          border = palette.light4;
          background = palette.dark1;
          text = palette.dark4;
          indicator = palette.neutral_purple;
          childBorder = palette.dark4;
        };
        urgent = {
          border = palette.neutral_red;
          background = palette.neutral_red;
          text = palette.dark1;
          indicator = palette.neutral_purple;
          childBorder = palette.neutral_red;
        };
        placeholder = {
          border = palette.neutral_green;
          background = palette.dark1;
          text = palette.light1;
          indicator = palette.neutral_purple;
          childBorder = palette.neutral_green;
        };
      };

      foot = {
        inherit alpha;
      }
      // builtins.mapAttrs (_: rgb: lib.removePrefix "#" rgb) {
        background = palette.dark1;
        foreground = palette.light1;
        regular0 = palette.dark1;
        regular1 = palette.neutral_red;
        regular2 = palette.neutral_green;
        regular3 = palette.neutral_yellow;
        regular4 = palette.neutral_blue;
        regular5 = palette.neutral_purple;
        regular6 = palette.neutral_aqua;
        regular7 = palette.light4;
        bright0 = palette.gray_245;
        bright1 = palette.neutral_red;
        bright2 = palette.neutral_green;
        bright3 = palette.neutral_yellow;
        bright4 = palette.neutral_blue;
        bright5 = palette.neutral_purple;
        bright6 = palette.neutral_aqua;
        bright7 = palette.light1;
      };

      # strip hashtag prefix and append alpha value (ff)
      fuzzel = builtins.mapAttrs (_: rgb: "${lib.removePrefix "#" rgb}ff") ({
        background = palette.dark1;
        text = palette.light1;
        message = palette.light1;
        prompt = palette.light1;

        placeholder = palette.light1;
        input = palette.light1;
        match = palette.light1;

        selection = palette.neutral_green;
        selection_text = palette.light1;
        selection_match = palette.light1;

        counter = palette.light1;
        border = palette.light1;
      });

      niri = {
        border = {
          active = {
            color = palette.light1;
          };
          inactive = {
            color = palette.dark1;
          };
          urgent = {
            color = palette.neutral_red;
          };
        };
        focus-ring = {
        };
        shadow = {
        };
      };

      # waybar style.css as a string
      waybar = ''
        * {
          border-radius: 0;
          font-family: "MesloLGM Nerd Font", "Font Awesome 5 Free";
          color: ${palette.light1};
          font-size: 16px;
        }

        window#waybar {
          background-color: transparent;
          color: ${palette.light1};
        }

        #clock,
        #battery,
        #cpu,
        #mpris,
        #workspaces,
        #scratchpad,
        #memory,
        #backlight,
        #idle_inhibitor,
        #wireplumber,
        #network {
          background-color: alpha(${palette.dark1}, ${alpha});
          color: ${palette.light1};
          margin: 2px;
          padding: 4px 12px;
          border: 1px solid ${palette.light1};
        }

        tooltip {
          background-color: alpha(${palette.dark1}, ${alpha});
          border: 1px solid ${palette.light1};
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
          margin: 0 2px;
        }

        #workspaces button.focused {
          background-color: alpha(${palette.dark4}, ${alpha});
        }
      '';

    };

}

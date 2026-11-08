# Kanagawa color palette by rebelot
# https://github.com/rebelot/kanagawa.nvim
{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
{
  flake.themes.gruvbox-dark =
    let
      palette = {
        fujiWhite = "#DCD7BA";
        oldWhite = "#C8C093";
        sumiInk0 = "#16161D";
        sumiInk1 = "#1F1F28";
        sumiInk2 = "#2A2A37";
        sumiInk3 = "#363646";
        sumiInk4 = "#54546D";
        waveBlue1 = "#223249";
        waveBlue2 = "#2D4F67";
        winterGreen = "#2B3328";
        winterYellow = "#49443C";
        winterRed = "#43242B";
        winterBlue = "#252535";
        autumnGreen = "#76946A";
        autumnRed = "#C34043";
        autumnYellow = "#DCA561";
        samuraiRed = "#E82424";
        roninYellow = "#FF9E3B";
        waveAqua1 = "#6A9589";
        dragonBlue = "#658594";
        fujiGray = "#727169";
        springViolet1 = "#938AA9";
        oniViolet = "#957FB8";
        crystalBlue = "#7E9CD8";
        springViolet2 = "#9CABCA";
        springBlue = "#7FB4CA";
        lightBlue = "#A3D4D5";
        waveAqua2 = "#7AA89F";
        springGreen = "#98BB6C";
        boatYellow1 = "#938056";
        boatYellow2 = "#C0A36E";
        carpYellow = "#E6C384";
        sakuraPink = "#D27E99";
        waveRed = "#E46876";
        peachRed = "#FF5D62";
        surimiOrange = "#FFA066";
        katanaGray = "#717C7C";
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

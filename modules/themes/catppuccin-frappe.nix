# Catppuccin Frappe color palette
{
  inputs,
  ...
}:
let
  lib = inputs.nixpkgs.lib;
in
{
  flake.themes.catppuccin-frappe =
    let
      palette = {
        rosewater = "#f2d5cf";
        flamingo = "#eebebe";
        pink = "#f4b8e4";
        mauve = "#ca9ee6";
        red = "#e78284";
        maroon = "#ea999c";
        peach = "#ef9f76";
        yellow = "#e5c890";
        green = "#a6d189";
        teal = "#81c8be";
        sky = "#99d1db";
        sapphire = "#85c1dc";
        blue = "#8caaee";
        lavender = "#babbf1";
        text = "#c6d0f5";
        subtext1 = "#b5bfe2";
        subtext0 = "#a5adce";
        overlay2 = "#949cbb";
        overlay1 = "#838ba7";
        overlay0 = "#737994";
        surface2 = "#626880";
        surface1 = "#51576d";
        surface0 = "#414559";
        base = "#303446";
        mantle = "#292c3c";
        crust = "#232634";
      };
      theme = with palette; {
        # surfaces
        background = base; # main bg (foot, fuzzel, waybar, sway)
        backgroundAlt = surface0; # raised/selected surface (waybar focused workspace)
        foreground = text; # main text

        # text variants
        foregroundDim = subtext0; # unfocused/secondary text
        muted = overlay1; # placeholders, disabled

        borderActive = text;
        borderInactive = surface1;
        accent = mauve;

        selection = surface2;
        selectionText = text;

        # status
        urgent = red;
        success = green;
        warning = yellow;
        info = sky;

        # terminal ANSI, which every scheme has to supply
        ansi = {
          black = surface1;
          brightBlack = surface2;
          red = red;
          brightRed = red;
          green = green;
          brightGreen = green;
          yellow = yellow;
          brightYellow = yellow;
          blue = blue;
          brightBlue = blue;
          magenta = pink;
          brightMagenta = pink;
          cyan = teal;
          brightCyan = teal;
          white = subtext1;
          brightWhite = subtext0;
        };
      };
      alpha = "1.00";
    in
    {
      inherit palette;

      foot = {
        inherit alpha;
      }
      // builtins.mapAttrs (_: rgb: lib.removePrefix "#" rgb) {
        background = theme.background;
        foreground = theme.foreground;

        regular0 = theme.ansi.black;
        regular1 = theme.ansi.red;
        regular2 = theme.ansi.green;
        regular3 = theme.ansi.yellow;
        regular4 = theme.ansi.blue;
        regular5 = theme.ansi.magenta;
        regular6 = theme.ansi.cyan;
        regular7 = theme.ansi.white;
        bright0 = theme.ansi.brightBlack;
        bright1 = theme.ansi.brightRed;
        bright2 = theme.ansi.brightGreen;
        bright3 = theme.ansi.brightYellow;
        bright4 = theme.ansi.brightBlue;
        bright5 = theme.ansi.brightMagenta;
        bright6 = theme.ansi.brightCyan;
        bright7 = theme.ansi.brightWhite;
      };

      # strip hashtag prefix and append alpha value (ff)
      fuzzel = builtins.mapAttrs (_: rgb: "${lib.removePrefix "#" rgb}ff") ({
        background = theme.background;
        text = theme.foreground;
        message = theme.foreground;
        prompt = theme.foreground;

        placeholder = theme.foreground;
        input = theme.foreground;
        match = theme.foreground;

        selection = theme.selection;
        selection_text = theme.foreground;
        selection_match = theme.foreground;

        counter = theme.foreground;
        border = theme.foreground;
      });

      niri = {
        border = {
          active = {
            color = theme.borderActive;
          };
          inactive = {
            color = theme.borderInactive;
          };
          urgent = {
            color = theme.urgent;
          };
        };
        focus-ring = {
          active = {
            color = theme.foreground;
          };
          inactive = {
            color = theme.background;
          };
          urgent = {
            color = theme.urgent;
          };
        };
        shadow = {
        };
      };

      # waybar style.css as a string
      waybar = ''
        * {
          border-radius: 0;
          font-family: "MesloLGM Nerd Font", "Font Awesome 5 Free";
          color: ${theme.foreground};
          font-size: 16px;
        }

        window#waybar {
          background-color: transparent;
          color: ${theme.foreground};
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
          background-color: alpha(${theme.background}, ${alpha});
          color: ${theme.foreground};
          margin: 2px;
          padding: 4px 12px;
          border: 1px solid ${theme.foreground};
        }

        tooltip {
          background-color: alpha(${theme.background}, ${alpha});
          border: 1px solid ${theme.foreground};
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
          background-color: alpha(${theme.selection}, ${alpha});
        }
      '';

    };

}

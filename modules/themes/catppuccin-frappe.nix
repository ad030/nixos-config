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

      rofi = ''
        * {
          rosewater: #f2d5cf;
          flamingo: #eebebe;
          pink: #f4b8e4;
          mauve: #ca9ee6;
          red: #e78284;
          maroon: #ea999c;
          peach: #ef9f76;
          yellow: #e5c890;
          green: #a6d189;
          teal: #81c8be;
          sky: #99d1db;
          sapphire: #85c1dc;
          blue: #8caaee;
          lavender: #babbf1;
          text: #c6d0f5;
          subtext1: #b5bfe2;
          subtext0: #a5adce;
          overlay2: #949cbb;
          overlay1: #838ba7;
          overlay0: #737994;
          surface2: #626880;
          surface1: #51576d;
          surface0: #414559;
          base: #303446;
          mantle: #292c3c;
          crust: #232634;
        }

        * {
          selected-active-foreground:  @background;
          lightfg:                     @text;
          separatorcolor:              @foreground;
          urgent-foreground:           @red;
          alternate-urgent-background: @lightbg;
          lightbg:                     @mantle;
          background-color:            transparent;
          border-color:                @foreground;
          normal-background:           @background;
          selected-urgent-background:  @red;
          alternate-active-background: @lightbg;
          spacing:                     2;
          alternate-normal-foreground: @foreground;
          urgent-background:           @background;
          selected-normal-foreground:  @lightbg;
          active-foreground:           @blue;
          background:                  @base;
          selected-active-background:  @blue;
          active-background:           @background;
          selected-normal-background:  @lightfg;
          alternate-normal-background: @lightbg;
          foreground:                  @text;
          selected-urgent-foreground:  @background;
          normal-foreground:           @foreground;
          alternate-urgent-foreground: @red;
          alternate-active-foreground: @blue;
        }

        element {
            padding: 1px ;
            cursor:  pointer;
            spacing: 5px ;
            border:  0;
        }
        element normal.normal {
            background-color: @normal-background;
            text-color:       @normal-foreground;
        }
        element normal.urgent {
            background-color: @urgent-background;
            text-color:       @urgent-foreground;
        }
        element normal.active {
            background-color: @active-background;
            text-color:       @active-foreground;
        }
        element selected.normal {
            background-color: @selected-normal-background;
            text-color:       @selected-normal-foreground;
        }
        element selected.urgent {
            background-color: @selected-urgent-background;
            text-color:       @selected-urgent-foreground;
        }
        element selected.active {
            background-color: @selected-active-background;
            text-color:       @selected-active-foreground;
        }
        element alternate.normal {
            background-color: @alternate-normal-background;
            text-color:       @alternate-normal-foreground;
        }
        element alternate.urgent {
            background-color: @alternate-urgent-background;
            text-color:       @alternate-urgent-foreground;
        }
        element alternate.active {
            background-color: @alternate-active-background;
            text-color:       @alternate-active-foreground;
        }
        element-text {
            background-color: transparent;
            cursor:           inherit;
            highlight:        inherit;
            text-color:       inherit;
        }
        element-icon {
            background-color: transparent;
            size:             1.0000em ;
            cursor:           inherit;
            text-color:       inherit;
        }
        window {
            padding:          5;
            background-color: @background;
            border:           1;
        }
        mainbox {
            padding: 0;
            border:  0;
        }
        message {
            padding:      1px ;
            border-color: @separatorcolor;
            border:       2px dash 0px 0px ;
        }
        textbox {
            text-color: @foreground;
        }
        listview {
            padding:      2px 0px 0px ;
            scrollbar:    true;
            border-color: @separatorcolor;
            spacing:      2px ;
            fixed-height: 0;
            border:       2px dash 0px 0px ;
        }
        scrollbar {
            width:        4px ;
            padding:      0;
            handle-width: 8px ;
            border:       0;
            handle-color: @normal-foreground;
        }
        sidebar {
            border-color: @separatorcolor;
            border:       2px dash 0px 0px ;
        }
        button {
            cursor:     pointer;
            spacing:    0;
            text-color: @normal-foreground;
        }
        button selected {
            background-color: @selected-normal-background;
            text-color:       @selected-normal-foreground;
        }
        num-filtered-rows {
            expand:     false;
            text-color: Gray;
        }
        num-rows {
            expand:     false;
            text-color: Gray;
        }
        textbox-num-sep {
            expand:     false;
            str:        "/";
            text-color: Gray;
        }
        inputbar {
            padding:    1px ;
            spacing:    0px ;
            text-color: @normal-foreground;
            children:   [ "prompt","textbox-prompt-colon","entry","num-filtered-rows","textbox-num-sep","num-rows","case-indicator" ];
        }
        case-indicator {
            spacing:    0;
            text-color: @normal-foreground;
        }
        entry {
            text-color:        @normal-foreground;
            cursor:            text;
            spacing:           0;
            placeholder-color: Gray;
            placeholder:       "Type to filter";
        }
        prompt {
            spacing:    0;
            text-color: @normal-foreground;
        }
        textbox-prompt-colon {
            margin:     0px 0.3000em 0.0000em 0.0000em ;
            expand:     false;
            str:        ":";
            text-color: inherit;
        }
      '';
    };

}

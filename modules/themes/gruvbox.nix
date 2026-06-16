## GRUVBOX THEME
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
      append_alpha = rgb: "${rgb}ff";
      prepend_alpha = rgb: "ff${rgb}";
      remove_hashtag_prefix = rgb: (lib.removePrefix "#" rgb);
    in
    {
      inherit palette;

      sway = {
        focused = {
          border = palette.light1;
          background = palette.dark1;
          text = palette.light1;
          indicator = palette.bright_purple;
          childBorder = palette.light0;
        };
        unfocused = {
          border = palette.light4;
          background = palette.dark1;
          text = palette.dark4;
          indicator = palette.bright_purple;
          childBorder = palette.dark4;
        };

        # same as unfocused
        focusedInactive = {
          border = palette.light4;
          background = palette.dark1;
          text = palette.dark4;
          indicator = palette.bright_purple;
          childBorder = palette.dark4;
        };
        urgent = {
          border = palette.bright_red;
          background = palette.bright_red;
          text = palette.dark1;
          indicator = palette.bright_purple;
          childBorder = palette.bright_red;
        };
        placeholder = {
          border = palette.bright_green;
          background = palette.dark1;
          text = palette.light1;
          indicator = palette.bright_purple;
          childBorder = palette.bright_green;
        };
      };

      foot = {
        alpha = "0.80";
      }
      // builtins.mapAttrs remove_hashtag_prefix {
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
        bright1 = palette.bright_red;
        bright2 = palette.bright_green;
        bright3 = palette.bright_yellow;
        bright4 = palette.bright_blue;
        bright5 = palette.bright_purple;
        bright6 = palette.bright_aqua;
        bright7 = palette.light1;
      };

      fuzzel = builtins.mapAttrs append_alpha (
        builtins.mapAttrs remove_hashtag_prefix {
          background = palette.dark1;
          text = palette.light1;
          message = palette.light1;
          prompt = palette.light1;

          placeholder = palette.light1;
          input = palette.light1;
          match = palette.light1;

          selection = palette.bright_green;
          selection_text = palette.light1;
          selection_match = palette.light1;

          counter = palette.light1;
          border = palette.light1;

        }
      );
    };
}

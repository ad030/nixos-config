## GRUVBOX THEME
{ self, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
{
  flake.modules.homeManager.gruvbox-dark =
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
        background = remove_hashtag_prefix palette.dark1;
        foreground = remove_hashtag_prefix palette.light1;
        regular0 = remove_hashtag_prefix palette.dark1;
        regular1 = remove_hashtag_prefix palette.neutral_red;
        regular2 = remove_hashtag_prefix palette.neutral_green;
        regular3 = remove_hashtag_prefix palette.neutral_yellow;
        regular4 = remove_hashtag_prefix palette.neutral_blue;
        regular5 = remove_hashtag_prefix palette.neutral_purple;
        regular6 = remove_hashtag_prefix palette.neutral_aqua;
        regular7 = remove_hashtag_prefix palette.light4;
        bright0 = remove_hashtag_prefix palette.gray_245;
        bright1 = remove_hashtag_prefix palette.bright_red;
        bright2 = remove_hashtag_prefix palette.bright_green;
        bright3 = remove_hashtag_prefix palette.bright_yellow;
        bright4 = remove_hashtag_prefix palette.bright_blue;
        bright5 = remove_hashtag_prefix palette.bright_purple;
        bright6 = remove_hashtag_prefix palette.bright_aqua;
        bright7 = remove_hashtag_prefix palette.light1;
      };

      fuzzel = {
        background = append_alpha (remove_hashtag_prefix palette.dark1);
        text = append_alpha (remove_hashtag_prefix palette.light1);
        message = append_alpha (remove_hashtag_prefix palette.light1);
        prompt = append_alpha (remove_hashtag_prefix palette.light1);

        placeholder = append_alpha (remove_hashtag_prefix palette.light1);
        input = append_alpha (remove_hashtag_prefix palette.light1);
        match = append_alpha (remove_hashtag_prefix palette.light1);

        selection = append_alpha (remove_hashtag_prefix palette.bright_green);
        selection_text = append_alpha (remove_hashtag_prefix palette.light1);
        selection_match = append_alpha (remove_hashtag_prefix palette.light1);

        counter = append_alpha (remove_hashtag_prefix palette.light1);
        border = append_alpha (remove_hashtag_prefix palette.light1);

      };
    };
}

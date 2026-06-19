{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.homeManager.foot =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      theme = self.themes.gruvbox-dark;
    in
    {
      programs.foot = {
        enable = true;

        settings = {
          main = {
            # font = "Fira Code Mono:size=14";
            font = "Meslo LGM Nerd Font Mono:size=14";
          };

          colors-dark = theme.foot;

          mouse = {
            hide-when-typing = "yes";
          };

        };
      };
    };

}

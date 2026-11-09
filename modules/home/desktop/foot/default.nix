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
      # theme = self.themes.gruvbox-dark.foot;
      theme = self.themes.catppuccin-frappe.foot;
    in
    {
      programs.foot = {
        enable = true;

        settings = {
          main = {
            # font = "Fira Code Mono:size=14";
            font = "Meslo LGM Nerd Font Mono:size=14";
            # font = "Noto Sans Mono:size=14";
          };

          colors-dark = theme;

          mouse = {
            hide-when-typing = "yes";
          };

        };
      };
    };

}

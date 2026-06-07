{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.homeManager.fuzzel =

    { pkgs, lib, ... }:
    let
      theme = self.themes.gruvbox-dark;
    in
    {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.foot}/bin/foot";
            layer = "overlay";
            font = "MesloLGM Nerd Font:size=12";
          };

          colors = theme.fuzzel;

        };
      };
    };
}

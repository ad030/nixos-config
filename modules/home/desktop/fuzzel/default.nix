{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.hm.fuzzel =

    { pkgs, lib, ... }:
    let
      theme = self.themes.gruvbox-dark;
    in
    {
      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${lib.getExe pkgs.foot}";
            layer = "overlay";
            font = "MesloLGM Nerd Font:size=12";
          };

          colors = theme.fuzzel;

        };
      };
    };
}

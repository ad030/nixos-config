{
  self,
  ...
}:
{
  flake.modules.homeManager.rofi =
    {
      pkgs,
      ...
    }:
    let
      themes = {
        gruvbox = "gruvbox-dark-soft";
        catppuccin-frappe = "${pkgs.writeText "rofi-theme.rasi" self.themes.catppuccin-frappe.rofi}";
      };
    in
    {

      programs.rofi = {
        enable = true;

        theme = themes.catppuccin-frappe;
        terminal = "foot";
        font = "MesloLGM Nerd Font Mono 16";
        # font = "Noto Nerd Font 16";

        modes = [
          "window"
          "drun"
          "run"
        ];

        cycle = true;

        location = "center";

        extraConfig = {
          icon-theme = "Papirus";
          show-icons = true;
          drun-display-format = "{icon} {name}";
        };

      };
    };
}

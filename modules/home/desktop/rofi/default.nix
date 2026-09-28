{
  flake.modules.homeManager.rofi = {
    programs.rofi = {
      enable = true;

      theme = "gruvbox-dark-soft";
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

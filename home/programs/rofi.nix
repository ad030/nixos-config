{ pkgs, ... }:

{

  programs = {
    rofi = {
      enable = true;

      theme = "gruvbox-dark";
      terminal = "foot";

      modes = [
        "window"
        "drun"
        "run"
      ];

      font = "Meslo LGM Regular 14";

      location = "center";

      extraConfig = {
        icon-theme = "Papirus";
        show-icons = true;
        drun-display-format = "{icon} {name}";
      };

    };

  };

}

{ config, pkgs, ... }:

{
  imports = [
    ../../modules/user
  ];

  home = {
    username = "ad030";
    homeDirectory = "/home/ad030";
    stateVersion = "25.11";
    packages = with pkgs; [
      ripgrep
      lua-language-server

      obsidian # note taking app

      nemo # file manager
    ];

    pointerCursor = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
      gtk.enable = true;
      x11.enable = true;
    };

  };

  nix = {
    settings.experimental-features = [
      # enable nix flakes
      "nix-command"
      "flakes"
    ];
  };

  gtk = {
    enable = true;
    colorScheme = "light";

    theme = {
      name = "Gruvbox";
      package = pkgs.gruvbox-gtk-theme;

    };
    iconTheme = {
      # name = "Papirus";
      # package = pkgs.papirus-icon-theme;
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
    font = {
      name = "MesloLGM Nerd Font";
      package = pkgs.nerd-fonts.meslo-lg;
      size = 12;
    };
    
  };

}

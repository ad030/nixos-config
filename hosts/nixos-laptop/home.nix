{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager
  ];

  home = {
    username = "ad030";
    homeDirectory = "/home/ad030";
    stateVersion = "25.11";
    packages = with pkgs; [
      ripgrep
      lua-language-server

      signal-desktop

      # window managers/compositors
      # niri 

      obsidian # note taking app

      # for sway
      swaylock
      swayidle
      waybar

      nemo
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

  xdg.desktopEntries = {
    signal = {
      categories = [
        # main category
        "Network"
        # additional categories
        "InstantMessaging"
        "Chat"
      ];

      exec = "signal-desktop --password-store=gnome-libsecret";
      genericName = "Private messaging app";

      name = "Signal";
      terminal = false;

    };
  };


}

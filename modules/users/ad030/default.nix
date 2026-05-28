{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../programs
  ];

  home = {
    username = "ad030";
    homeDirectory = "/home/ad030";
    stateVersion = "26.05";

    packages = with pkgs; [
      ripgrep
      lua-language-server

      obsidian # note taking app
      nemo # file manager

      (texliveBasic.withPackages (ps: [ ps.latexmk ]))
      biber
      python314Packages.pylatexenc

      libreoffice
      # zathura
      kdePackages.okular
      ani-cli
      jellyfin-desktop
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

  services = {
    ssh-agent.enable = true;
    gnome-keyring = {
      enable = lib.mkForce false;
      # components = [
      #   "pkcs11"
      #   "secrets"
      #   "ssh"
      # ];
    };
  };

  ## ENABLE PROGRAMS HERE
  programs = {
    keepassxc.enable = true;
    neovim.enable = true;

    bash.enable = true;
    foot.enable = true;

    niri.enable = true;

    fuzzel.enable = true;
    waybar.enable = true;

    tmux.enable = true;
  };

  ## WINDOW MANAGERS
  wayland.windowManager = {
    sway.enable = true;
  };
}

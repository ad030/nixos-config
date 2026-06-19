{
  self,
  inputs,
  ...
}:

{
  flake.hmUsers.nixuser =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with self.modules.homeManager; [
        core
        desktop
        dev
        gaming

        apps

        signal-desktop
        vesktop
        keepassxc
      ];

      home = {
        username = "nixuser";
        homeDirectory = "/home/nixuser";
        stateVersion = "26.05";

        packages = with pkgs; [
          obsidian # note taking app
          nemo # file manager

          papirus-icon-theme

          (texliveBasic.withPackages (ps: [ ps.latexmk ]))
          biber
          python314Packages.pylatexenc
        ];

        pointerCursor = {
          name = "Bibata-Modern-Ice";
          size = 24;
          package = pkgs.bibata-cursors;
          gtk.enable = true;
          x11.enable = true;
        };
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
        };
      };

      ## WINDOW MANAGERS
      wayland.windowManager.sway.extraOptions = [ "--unsupported-gpu" ];
    };
}

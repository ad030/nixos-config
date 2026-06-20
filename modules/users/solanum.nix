{
  self,
  inputs,
  ...
}:
let
  username = "solanum";
in
{
  flake.nixosUsers.${username} =
    { config, pkgs, ... }:
    {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      hashedPassword = "$y$j9T$avB97rOQS/qFTosBcYu/w.$1cDcc.hv8V69alJB1vdQ3hGrKIPlJtw.3/OWJPl0Ow9";
    };

  flake.hmUsers.${username} =
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
        username = username;
        homeDirectory = "/home/${username}";
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

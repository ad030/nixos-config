# primary user (me)
{
  self,
  inputs,
  ...
}:
let
  username = "esker";
in
{
  flake.modules.nixos."users-${username}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      sops.secrets."passwords/${username}".neededForUsers = true;

      users.users.${username} =
        let
          uid = self.lib.sharedIds.users.${username}.uid or null;
          groups = self.lib.sharedIds.users.${username}.groups or [ ];
        in
        {
          inherit uid;
          isNormalUser = true;
          shell = pkgs.bash;
          extraGroups = lib.uniqueStrings (
            [
              "networkmanager"
              "wheel"
              "input"
            ]
            ++ groups
          );
          hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
        };

      home-manager.users.${username}.imports = [
        self.modules.homeManager."users-${username}"
      ];
    };

  flake.modules.homeManager."users-${username}" =
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
        gaming

        nemo
      ];

      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = "26.05";
        pointerCursor = {
          enable = true;
          name = "Bibata-Modern-Ice";
          size = 24;
          package = pkgs.bibata-cursors;
          gtk.enable = true;
          x11.enable = true;
        };
      };

      gtk = {
        enable = true;
        gtk2.enable = false; # fixes ~/.config/gtk-2.0/gtkrc file clobbering issue

        colorScheme = "light";
        theme = {
          name = "catppuccin";
          package = pkgs.catppuccin-gtk;
        };
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Bibata-Modern-Ice";
          size = 24;
          package = pkgs.bibata-cursors;
        };
        font = {
          name = "Noto Nerd Font";
          package = pkgs.nerd-fonts.noto;
          size = 12;
        };
      };

      services = {
        gnome-keyring = {
          enable = true;
        };
      };

      # use nemo as default file manager
      xdg.mimeApps.defaultApplications =
        let
          imageViewer = "swayimg.desktop";
        in
        {
          "inode/directory" = [ "nemo.desktop" ];
          "application/x-gnome-saved-search" = [ "nemo.desktop" ];

          # image types
          "image/apng" = [ imageViewer ];
          "image/avif" = [ imageViewer ];
          "image/gif" = [ imageViewer ];
          "image/jpeg" = [ imageViewer ];
          "image/png" = [ imageViewer ];
          "image/svg+xml" = [ imageViewer ];
          "image/webp" = [ imageViewer ];
        };
    };
}

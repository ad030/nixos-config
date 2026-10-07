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
          extraGroups = [
            "networkmanager"
            "wheel"
            "input"
            "media"
          ];
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

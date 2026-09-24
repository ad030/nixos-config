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
  flake.nixosUsers.${username} =
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
    };

  flake.hmUsers.${username} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      homeDir = "/home/${username}";
    in
    {
      imports = with self.modules.homeManager; [
        core
        desktop
        gaming

        nemo
      ];

      home = {
        username = username;
        homeDirectory = homeDir;
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

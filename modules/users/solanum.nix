# primary user (me)
{
  self,
  inputs,
  ...
}:
let
  username = "solanum";
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
          extraGroups =
            lib.uniqueStrings [
              "networkmanager"
              "wheel"
            ]
            ++ groups;
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
    {
      imports = with self.modules.homeManager; [
        core
        desktop
        dev
        gaming
      ];

      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = "26.05";

        packages = with pkgs; [
          papirus-icon-theme
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

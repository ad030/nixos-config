{
  flake.modules.nixos.desktop-manager =
    {
      config,
      pkgs,
      ...
    }:

    {
      services = {
        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        xserver = {
          enable = true;
          # Configure keymap in X11
          xkb = {
            layout = "us";
            variant = "";
          };
        };

        # Enable touchpad support (enabled default in most desktopManager).
        libinput.enable = true;

        # Enable CUPS to print documents.
        printing.enable = true;
      };

      # Enable LXQt desktop manager
      services.xserver.desktopManager.lxqt = {
        enable = true;
        extraPackages = with pkgs; [
          kdePackages.kwin
          lxqt.lxqt-wayland-session
          papirus-icon-theme
        ];
      };
      xdg.portal.lxqt.enable = true;

      services.desktopManager = {
        plasma6.enable = false;
      };
      environment.plasma6.excludePackages = with pkgs; [
        kdePackages.elisa # Music player
        kdePackages.kdepim-runtime # Akonadi agents
        kdePackages.kmahjongg
        kdePackages.kmines
        kdePackages.konversation # IRC client
        kdePackages.kpat # Solitaire
        kdePackages.ksudoku
        kdePackages.ktorrent

        # fuck you bitch
        kdePackages.kwallet
        kdePackages.kwallet-pam
        kdePackages.kwalletmanager
        kdePackages.ksshaskpass
      ];
    };
}

{
  flake.modules.nixos.display-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        (pkgs.sddm-astronaut.override {
          embeddedTheme = "astronaut";
        })
        pkgs.bibata-cursors
      ];

      fonts.packages = [
        pkgs.open-sans
      ];

      services.displayManager = {
        defaultSession = lib.mkForce "niri";

        sddm = {
          enable = true;
          package = lib.mkForce pkgs.kdePackages.sddm;

          wayland = {
            enable = true;
            # need to set this because weston is shit
            # cursor does not appear without kwin
            compositor = "kwin";
          };

          theme = "sddm-astronaut-theme";

          # the theme will not load without this
          extraPackages = [
            pkgs.sddm-astronaut # this bit is needed!!!
          ];

          settings = {
            Theme = {
              CursorTheme = "Bibata-Modern-Ice";
              CursorSize = "24";
            };
          };
        };
      };
    };
}

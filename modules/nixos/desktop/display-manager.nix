{
  flake.modules.nixos.display-manager =
    {
      config,
      pkgs,
      ...
    }:

    {
      environment.systemPackages =
        let
          sddm-astronaut = (
            pkgs.sddm-astronaut.override {
              embeddedTheme = "black_hole";
            }
          );
        in
        [
          sddm-astronaut
        ];

      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;

          theme = "sddm-astronaut-theme";

          # the theme will not load without this
          extraPackages = [
            pkgs.sddm-astronaut # this bit is needed!!!
          ];
        };
      };
    };
}

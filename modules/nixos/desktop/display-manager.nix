{
  flake.modules.nixos.display-manager =
    {
      config,
      pkgs,
      ...
    }:

    {
      environment.systemPackages = with pkgs; [
        sddm-astronaut
      ];

      services.displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;

          theme = "sddm-astronaut-theme";
          extraPackages = [ pkgs.sddm-astronaut ];
        };

        # ly = {
        #   enable = true;
        #   settings = {
        #     numlock = false;
        #     bigclock = "en";
        #     vimode = true;
        #   };
        # };
      };
    };
}

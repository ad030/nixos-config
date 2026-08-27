{ self, inputs, ... }:
{
  flake.modules.nixos.window-manager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.niri.nixosModules.niri
        self.modules.nixos.idle-lock
      ];

      nixpkgs.overlays = [ inputs.niri.overlays.niri ];

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        quickshell # for creating custom status bar
      ];

      # force niri to use gtk desktop portal rather than gnome portal
      # https://wiki.nixos.org/wiki/Niri#File_picker_not_working
      xdg.portal.config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ]; # or "kde"
      };

      programs = {
        niri = {
          enable = true;
          package = pkgs.niri;
        };
        # sway = {
        #   enable = false;
        #   xwayland.enable = true;
        # };
        # hyprland = {
        #   enable = false;
        #   withUWSM = true;
        #   xwayland.enable = true;
        # };
      };
    };
}

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

      nixpkgs.overlays = [
        inputs.niri.overlays.niri
        # xwayland-satellite v0.8.2 has a dropdown menu bug for steam
        # temporary fix by reverting to 0.8.1
        # https://github.com/Supreeeme/xwayland-satellite/issues/468
        (final: prev: {
          xwayland-satellite = prev.xwayland-satellite.overrideAttrs (
            old:
            let
              version = "0.8.1";
              src = final.fetchFromGitHub {
                owner = "Supreeeme";
                repo = "xwayland-satellite";
                rev = "536bd32";
                hash = "sha256-BUE41HjLIGPjq3U8VXPjf8asH8GaMI7FYdgrIHKFMXA=";
              };
            in
            {
              inherit version src;
              cargoDeps = final.rustPlatform.fetchCargoVendor {
                inherit (old) pname;
                inherit version src;
                hash = "sha256-16L6gsvze+m7XCJlOA1lsPNELE3D364ef2FTdkh0rVY=";
              };
            }
          );
        })
      ];

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

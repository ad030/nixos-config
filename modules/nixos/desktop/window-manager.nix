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
        xwayland-satellite-unstable
        quickshell # for creating custom status bar
      ];

      programs = {
        sway = {
          enable = false;
          xwayland.enable = true;
        };

        niri = {
          enable = true;
          package = pkgs.niri;
        };

        hyprland = {
          enable = false;
          withUWSM = true;
          xwayland.enable = true;
        };
      };
    };
}

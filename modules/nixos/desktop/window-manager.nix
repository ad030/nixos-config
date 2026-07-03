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
        self.modules.nixos.idle-lock
      ];

      environment.systemPackages = with pkgs; [
        xwayland-satellite
      ];

      programs = {
        sway = {
          enable = false;
          xwayland.enable = true;
        };

        niri = {
          enable = true;
        };

        hyprland = {
          enable = false;
          withUWSM = true;
          xwayland.enable = true;
        };
      };
    };
}

{
  flake.modules.nixos.window-manager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # environment.systemPackages = with pkgs; [
      #   kitty
      # ];

      programs = {
        sway = {
          enable = true;
          xwayland.enable = true;
        };

        niri = {
          enable = false;
        };

        hyprland.enable = false;
      };
    };
}

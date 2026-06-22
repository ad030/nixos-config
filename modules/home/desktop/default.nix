{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    desktop-packages
    sway
    niri
    # hyprland

    waybar
    fuzzel
    foot
  ];
}

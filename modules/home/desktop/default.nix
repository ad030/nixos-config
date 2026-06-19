{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    desktop-packages
    sway
    hyprland

    waybar
    fuzzel
    foot
  ];
}

{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    sway
    hyprland

    waybar
    fuzzel
    foot
  ];
}

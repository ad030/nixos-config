{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    desktop-packages
    niri

    waybar
    fuzzel
    foot
  ];
}

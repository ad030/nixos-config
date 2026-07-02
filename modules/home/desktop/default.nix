{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    desktop-packages
    audio

    niri
    waybar
    fuzzel
    foot
  ];
}

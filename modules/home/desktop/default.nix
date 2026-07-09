{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    desktop-packages
    audio

    niri
    waybar
    quickshell
    fuzzel
    foot

    keepassxc
    vesktop
    signal-desktop
  ];
}

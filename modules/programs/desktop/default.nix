{ config, ... }:
{
  flake.modules.homeManager.desktop.imports = with config.flake.modules.homeManager; [
    sway
    waybar
    fuzzel
    foot
  ];
}

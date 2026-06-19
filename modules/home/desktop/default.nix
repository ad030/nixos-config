{ config, ... }:
{
  flake.modules.hm.desktop.imports = with config.flake.modules.hm; [
    sway
    hyprland

    waybar
    fuzzel
    foot
  ];
}

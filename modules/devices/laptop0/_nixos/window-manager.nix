{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    sway = {
      enable = true;
      xwayland.enable = true;
    };

    niri.enable = false;
  };
}

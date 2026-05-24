{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.niri ];

  programs.niri = {
    enable = false;
    settings = {
      binds = lib.mkOptionDefault {
        "Mod+Return".action.spawn = "foot"; 
      };
      layout = {
        gaps = 2;
        focus-ring = {
          enable = true;
          width = 2;
        };
      };
    };
  };

}

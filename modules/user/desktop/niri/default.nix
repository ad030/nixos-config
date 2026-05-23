{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.niri ];

  programs.niri = {
    enable = true;
    settings = {
      binds = lib.mkOptionDefault {
        "Mod+Enter".action.spawn = "foot"; 
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

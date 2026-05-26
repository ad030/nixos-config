{ pkgs, ... }:

{
  home.file.".config/DankMaterialShell/settings.json" = {
    source = ./settings.json;
  };

  programs.dank-material-shell = { 
    enable = false;

    # settings = {
    #   theme = "dark";
    #   dynamicTheming = true;
    # };

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    # niri = {
    #   # enableKeybinds = true;
    #   enableSpawn = true;
    # };
  };
}

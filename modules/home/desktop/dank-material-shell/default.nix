{
  flake.modules.homeManager.dank-material-shell =
    { pkgs, ... }:

    {
      # home.file.".config/DankMaterialShell/settings.json" = {
      #   source = ./settings.json;
      # };

      programs.dank-material-shell = {
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
    };
}

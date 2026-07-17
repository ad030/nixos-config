{
  flake.modules.homeManager.xdg =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home = {
        packages = [ pkgs.xdg-utils ];
        preferXdgDirectories = true;
      };

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;

          extraConfig = {
            GAMES = "${config.home.homeDirectory}/Games";
            VAULTS = "${config.home.homeDirectory}/Vaults"; # obsidian vaults
          };
        };
        mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
      };
    };
}

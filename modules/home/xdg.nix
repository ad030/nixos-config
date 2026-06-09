{
  flake.modules.homeManager.dg =
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
        userDirs.enable = true;
      };

      mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
    };

}

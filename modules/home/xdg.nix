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
        userDirs.enable = true;
        mimeApps.enable = pkgs.stdenv.hostPlatform.isLinux;
      };

    };

}

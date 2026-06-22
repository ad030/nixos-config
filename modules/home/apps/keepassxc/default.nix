{
  flake.modules.homeManager.keepassxc =

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      xdg.autostart.enable = true;

      programs.keepassxc = {
        enable = true;
        autostart = true;

        settings = {
          Security = {
            LockDatabaseIdle = false;
            LockDatabaseMinimize = false;
          };
          GUI = {
            MinimizeToTray = true;
            MinimizeOnClose = true;
          };
          Browser = {
            Enabled = true;
          };
        };
      };

    };
}

{
  flake.modules.homeManager.keepassxc =

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.keepassxc = {
        enable = true;

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

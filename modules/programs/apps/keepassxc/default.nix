{
  flake.modules.homeManager.keepassxc =

    { pkgs, ... }:

    {
      programs.keepassxc = {
        enable = true;
        autostart = true;
        settings = {
          FdoSecrets = {
            Enabled = true;
            ConfirmAccessItem = false;
          };

          SSHAgent = {
            Enabled = true;
            UseOpenSSH = true;
          };

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

      xdg.autostart.enable = true;
    };
}

{
  flake.modules.hm.keepassxc =

    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services = {
        ssh-agent.enable = true;
        gnome-keyring = {
          enable = lib.mkForce false;
        };
      };

      xdg.autostart.enable = true;

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

    };
}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.idle-server = {
    # disable sleep, suspend, hibernate on server
    systemd.sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowSuspendThenHibernate = "no";
      AllowHybridSleep = "no";
    };

    # screen turns off after 60 seconds of inactivity
    boot.kernelParams = [
      "consoleblank=60"
    ];
  };
}

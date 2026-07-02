{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sleep = {
    # disable sleep, suspend, hibernate on server
    systemd.sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowSuspendThenHibernate = "no";
      AllowHybridSleep = "no";
    };
  };
}

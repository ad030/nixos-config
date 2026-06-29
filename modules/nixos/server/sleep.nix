{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.sleep = {
    systemd.sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowSuspendThenHibernate = "no";
      AllowHybridSleep = "no";
    };
  };
}

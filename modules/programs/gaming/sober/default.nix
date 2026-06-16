{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.sober = {
    services.flatpak.packages = [ "flathub:app/org.vinegarhq.Sober/x86_64/stable" ];
  };
}

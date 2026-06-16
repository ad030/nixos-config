{
  self,
  inputs,
  ...
}:

{
  flake.modules.homeManager.sober = {
    services.flatpak.packages = [ "flathub:app/org.vinegarhq.sober/x86_64/stable" ];
  };
}

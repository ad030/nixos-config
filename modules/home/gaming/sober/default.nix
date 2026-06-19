{
  self,
  inputs,
  ...
}:
{
  imports = with self.modules.hm; [
    flatpak
  ];
  flake.modules.hm.sober = {
    services.flatpak.packages = [ "flathub:app/org.vinegarhq.Sober/x86_64/stable" ];
  };
}

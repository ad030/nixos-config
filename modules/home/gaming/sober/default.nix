{
  self,
  inputs,
  ...
}:
{

  flake.modules.homeManager.sober = {
    imports = with self.modules.homeManager; [
      flatpak
    ];
    services.flatpak.packages = [ "flathub:app/org.vinegarhq.Sober/x86_64/stable" ];
  };
}

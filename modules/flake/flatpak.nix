{ self, inputs, ... }:
{
  flake.modules.homeManager.flatpak = {
    imports = [ inputs.d-flatpak.homeModules.default ];

    services.flatpak = {
      enable = true;
      remotes = {
        flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };
  };
}

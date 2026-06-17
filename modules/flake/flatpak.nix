{ self, inputs, ... }:
{
  flake.modules.homeManager.flatpak = {
    imports = [
      inputs.d-flatpak.homeModules.default
      # inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ];
    services.flatpak.remotes = {
      flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
  };

  flake.modules.nixos.flatpak = {
    services.flatpak.enable = true;
  };
}

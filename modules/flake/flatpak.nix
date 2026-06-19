{ self, inputs, ... }:
{
  flake.modules.hm.flatpak = {
    imports = [
      inputs.d-flatpak.hm.default
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

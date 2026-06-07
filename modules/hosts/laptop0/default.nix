{ self, inputs, ... }:

{
  flake.nixosConfigurations.laptop0 = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_nixos/configuration.nix
    ];
    specialArgs = { };
  };
}

{
  self,
  inputs,
  config,
  ...
}:

{
  flake.nixosConfigurations.laptop0 = inputs.nixpkgs-unstable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_nixos/configuration.nix
      config.flake.modules.nixos.home-manager
      { home-manager.users.ad030 = config.flake.homeConfigurations.ad030; }
      { _module.args = { inherit self inputs; }; }
    ];
    specialArgs = { inherit self inputs; };
  };
}

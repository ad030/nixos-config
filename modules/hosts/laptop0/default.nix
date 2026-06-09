{
  self,
  inputs,
  config,
  ...
}:
let
  nixpkgs = inputs.nixpkgs-unstable;
in
{
  flake.nixosConfigurations.laptop0 = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_nixos/configuration.nix
      config.flake.modules.nixos.home-manager
      { _module.args = { inherit self inputs; }; }
    ]
    # home manager users
    ++ (with config.flake.homeUsers; [
      { home-manager.users.ad030 = ad030; }
      { home-manager.users.nixuser = nixuser; }
    ]);
    specialArgs = { inherit self inputs; };
  };
}

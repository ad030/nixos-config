{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "home0";
  nixpkgs = inputs.nixpkgs-unstable;
in
{
  flake.nixosConfigurations.laptop0 = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_nixos/configuration.nix
      { networking.hostName = hostname; }
    ]
    # nixos modules
    ++ (with config.flake.modules.nixos; [
      core
      desktop
      home-manager
    ])
    # home manager users
    ++ (with config.flake.homeUsers; [
      { home-manager.users.nixuser = nixuser; }
    ]);
  };
}

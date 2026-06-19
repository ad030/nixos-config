{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "laptop0";
  nixpkgs = inputs.nixpkgs-stable;
in
{
  flake.nixosConfigurations.laptop0 = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_nixos/configuration.nix
      { networking.hostName = hostname; }
      { nixpkgs.config.allowUnfree = true; }
    ]
    # nixos modules
    ++ (with config.flake.modules.nixos; [
      core
      home-manager
    ])
    # home manager users
    ++ (with config.flake.homeUsers; [
    ]);
  };
}

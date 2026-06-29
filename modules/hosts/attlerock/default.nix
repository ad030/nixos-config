{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "attlerock";
  nixpkgs = inputs.nixpkgs-stable;
  systemUsers = [ "esker" ];
in
{
  flake.nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_nixos/configuration.nix
      { networking.hostName = hostname; }
      { nixpkgs.config.allowUnfree = true; }
    ]
    # nixos modules
    ++ (with config.flake.modules.nixos; [
      core
      server
    ])
    # users in nixos configuration
    ++ (map (user: config.flake.modules.nixos."users-${user}") systemUsers);
  };
}

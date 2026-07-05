{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "timber-hearth";
  nixpkgs = inputs.nixpkgs-unstable;
  systemUsers = [ "solanum" ];
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
      home-manager
      desktop
      gaming
      flatpak
    ])
    # users in nixos configuration
    ++ (map (user: config.flake.nixosUsers.${user}) systemUsers)
    # user configs in home manager
    ++ [
      {
        home-manager.users = nixpkgs.lib.genAttrs systemUsers (user: config.flake.hmUsers.${user});
      }
    ];
  };
}

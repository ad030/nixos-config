{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "brittle-hollow";
  nixpkgs = inputs.nixpkgs;
  systemUsers = [ "solanum" ];
  hostPlatform = "x86_64-linux";
in
{
  flake.nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    modules = [
      { nixpkgs.hostPlatform = hostPlatform; }
      ./_nixos/configuration.nix
      { networking.hostName = hostname; }
      { nixpkgs.config.allowUnfree = true; }
    ]
    # nixos modules
    ++ (with config.flake.modules.nixos; [
      core
      home-manager
      laptop
      desktop
      dev

      window-manager
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

{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "timber-hearth";
  nixpkgs = inputs.nixpkgs-unstable;
  systemUsers = [
    "solanum"
    "chert"
  ];
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
      nvidia
      home-manager
      desktop
      gaming
      flatpak
      dev

      desktop-environment
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

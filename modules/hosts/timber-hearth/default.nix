{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "timber-hearth";
  nixpkgs = inputs.nixpkgs;
  systemUsers = [
    "solanum"
    "chert"
    "esker"
  ];
  hostPlatform = "x86_64-linux";
in
{
  flake.nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
    modules = [
      { nixpkgs.hostPlatform = hostPlatform; }
      { networking.hostName = hostname; }
      { nixpkgs.config.allowUnfree = true; }
      ./_nixos
      ./_home
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
    ++ (map (user: config.flake.modules.nixos."users-${user}") systemUsers);
  };
}

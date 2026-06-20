{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "brittle-hollow";
  nixpkgs = inputs.nixpkgs-unstable;
  systemUsers = [ "nixuser" ];
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
    # home manager users
    ++ [
      {
        home-manager.users = nixpkgs.lib.genAttrs systemUsers (user: config.flake.hmUsers.${user});
      }
    ];
  };
}

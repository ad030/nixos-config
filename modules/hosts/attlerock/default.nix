{
  self,
  inputs,
  config,
  ...
}:
let
  hostname = "attlerock";
  nixpkgs = inputs.nixpkgs-stable;
in
{
  flake.nixosConfigurations."${hostname}" =
    { lib, ... }:
    (nixpkgs.lib.nixosSystem {
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
      # add shared users to this system
      ++ (
        let
          sharedUsers = self.lib.sharedIds.users;
        in
        [
          {
            users.users = lib.mapAttrs (name: user: {
              uid = user.uid;
              isSystemUser = true;
              group = "nogroup";
              extraGroups = user.groups;
              hashedPassword = "!";
            }) sharedUsers;
          }
        ]
      );
    });
}

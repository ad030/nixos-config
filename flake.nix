{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: {

    nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/nixos-laptop/configuration.nix
      ];
    };
  };
}

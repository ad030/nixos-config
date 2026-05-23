{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, noctalia, ... } @ inputs: {

    nixosConfigurations = {

      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/nixos-laptop/configuration.nix
          home-manager.nixosModules.home-manager
	  {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
	      extraSpecialArgs = { inherit inputs; };
              backupFileExtension = "backup";
              users.ad030 = import ./hosts/nixos-laptop/home.nix;

              sharedModules = [
                niri.homeModules.niri
                noctalia.homeModules.default
              ];
            };
	  }
        ];
      };

    };
  };

}

{
  description = "A very basic flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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

  outputs = { self, nixpkgs-unstable, home-manager-unstable, niri, noctalia, ... } @ inputs: {

    nixosConfigurations = {

      nixos-laptop = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./modules
          home-manager-unstable.nixosModules.home-manager
	  {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
	      extraSpecialArgs = { inherit inputs; };
              backupFileExtension = "backup";
              users.ad030 = import ./modules/hosts/nixos-laptop/home.nix;

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

{
  description = "A very basic flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
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
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    # dank material shell
    # dms = {
    #   url = "github:AvengeMedia/DankMaterialShell/stable";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      home-manager-unstable,
      niri,
      vicinae,
      vicinae-extensions,
      # noctalia,
      # dms,
      ...
    }:
    {

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
                users.ad030 = import ./modules/users/ad030;

                sharedModules = [
                  niri.homeModules.niri
                  vicinae.homeManagerModules.default

                  # noctalia.homeModules.default
                  # dms.homeModules.dank-material-shell
                ];
              };
            }
          ];
        };

      };
    };

}

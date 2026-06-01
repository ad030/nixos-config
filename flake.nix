{
  description = "A very basic flake";

  nixConfig = {
    abort-on-warn = true;
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    };

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # home-manager-stable = {
    #   url = "github:nix-community/home-manager/release-25.11";
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };
    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   # inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    # dank material shell
    # dms = {
    #   url = "github:AvengeMedia/DankMaterialShell/stable";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    # vicinae = {
    #   url = "github:vicinaehq/vicinae";
    #   # inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
    #
    # vicinae-extensions = {
    #   url = "github:vicinaehq/extensions";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  # inputs@{
  #   self,
  #   nixpkgs-unstable,
  #   home-manager,
  #   niri,
  #   # vicinae,
  #   # vicinae-extensions,
  #   # noctalia,
  #   # dms,
  #   ...
  # }:
  # {
  #
  #   nixosConfigurations = {
  #
  #     nixos-laptop = nixpkgs-unstable.lib.nixosSystem {
  #       system = "x86_64-linux";
  #
  #       specialArgs = { inherit inputs; };
  #
  #       modules = [
  #         ./modules
  #         home-manager.nixosModules.home-manager
  #         {
  #           home-manager = {
  #             useUserPackages = true;
  #             useGlobalPkgs = true;
  #             extraSpecialArgs = { inherit inputs; };
  #             backupFileExtension = "backup";
  #             users.ad030 = import ./modules/users/ad030;
  #
  #             sharedModules = [
  #               niri.homeModules.niri
  #               # vicinae.homeManagerModules.default
  #
  #               # noctalia.homeModules.default
  #               # dms.homeModules.dank-material-shell
  #             ];
  #           };
  #         }
  #       ];
  #     };
  #
  #   };
  # };

}

{
  description = "A very basic flake";

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

    d-flatpak = {
      url = "github:in-a-dil-emma/declarative-flatpak/latest";
    };

    # nix-flatpak = {
    #   url = "github:gmodena/nix-flatpak/?ref=latest";
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

    # vicinae-extensions = {
    #   url = "github:vicinaehq/extensions";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

}

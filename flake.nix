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

    # declarative flatpak installation
    d-flatpak = {
      url = "github:in-a-dil-emma/declarative-flatpak/latest";
    };

    # wayland scrolling window manager
    niri = {
      url = "github:sodiboo/niri-flake";
    };

    # secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    # declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}

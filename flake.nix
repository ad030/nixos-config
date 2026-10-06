{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declarative flatpak installation
    d-flatpak = {
      url = "github:in-a-dil-emma/declarative-flatpak/latest";
    };

    # wayland scrolling window manager
    niri = {
      # url = "github:sodiboo/niri-flake";
      url = "github:epireyn/niri-flake";
    };

    # secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    # declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TEMPORARY: zotero fails to build due to deprecated version of firefox ESR
    # add this until it is fixed
    # https://github.com/NixOS/nixpkgs/issues/568692
    nixpkgs-zotero.url = "github:NixOS/nixpkgs/7a0f122f5090cf4c2ade2a13a0e229d4e19ba71f";

    # anime games launcher
    aagl = {
      # url = "github:ezKEa/aagl-gtk-on-nix";
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}

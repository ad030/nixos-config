{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-unstable";
    };

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    # xwayland-satellite v0.8.2 has a dropdown menu bug for steam
    # temporary fix by reverting to 0.8.1
    # https://github.com/Supreeeme/xwayland-satellite/issues/468
    "nixpkgs-xwayland-satellite-0.8.1" = {
      url = "github:NixOS/nixpkgs/edfd59b795cd752c36d2dae60870cffcd23d3fb1";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}

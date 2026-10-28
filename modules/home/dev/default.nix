{
  self,
  inputs,
  config,
  ...
}:

{
  flake.modules.homeManager.dev = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      core
      neovim
      tmux

      tools-databases
      tools-documentation
    ];

    home.packages = with pkgs; [
      gh # github cli
      godot # game engine
      nixpkgs-review # for reviewing nixpkgs PRs
    ];
  };
}

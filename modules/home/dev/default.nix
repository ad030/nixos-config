{
  self,
  inputs,
  config,
  ...
}:

{
  flake.modules.homeManager.dev = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      neovim
      tmux
    ];

    home.packages = with pkgs; [
      gh # github cli
      godot # game engine
    ];
  };
}

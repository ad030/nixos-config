{
  self,
  inputs,
  config,
  ...
}:

{
  flake.modules.homeManager.dev.imports = with config.flake.modules.homeManager; [
    neovim
    tmux
  ];
}

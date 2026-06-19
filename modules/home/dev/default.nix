{
  self,
  inputs,
  config,
  ...
}:

{
  flake.modules.hm.dev.imports = with config.flake.modules.hm; [
    neovim
    tmux
  ];
}

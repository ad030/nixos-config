{ config, ... }:

{
  flake.modules.hm.core.imports = with config.flake.modules.hm; [
    bash
    nix
    xdg
  ];
}

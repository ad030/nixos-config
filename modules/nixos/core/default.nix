{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.core.imports = with config.flake.modules.nixos; [
    bootloader
    display-manager
    package-caches
    nix-settings
    core-packages
    fonts
  ];
}

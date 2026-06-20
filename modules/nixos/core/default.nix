{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.core.imports = with config.flake.modules.nixos; [
    bootloader
    network
    package-caches
    nix-settings
    core-packages
    fonts
    users-settings
    ssh
  ];
}

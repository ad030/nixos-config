{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.desktop.imports = with config.flake.modules.nixos; [
    desktop-manager
    display-manager
    compositor
    desktop-packages
    home-manager
  ];
}

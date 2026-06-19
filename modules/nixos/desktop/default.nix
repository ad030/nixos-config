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
    window-manager
    desktop-packages
    home-manager
  ];
}

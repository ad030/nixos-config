{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.laptop.imports = with config.flake.modules.nixos; [
    laptop-power-management
  ];
}

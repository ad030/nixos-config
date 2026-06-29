{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.power-management = {
    powerManagement.enable = true;
  };
}

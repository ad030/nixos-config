{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.laptop = {
    imports = with config.flake.modules.nixos; [
      core
      laptop-power-management
    ];
  };
}

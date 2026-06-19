{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.hm.gaming.imports = with config.flake.modules.hm; [
    lutris
    sober
  ];
}

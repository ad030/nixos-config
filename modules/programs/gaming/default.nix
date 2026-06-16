{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.homeManager.gaming.imports = with config.flake.modules.homeManager; [
    # lutris
    sober
  ];
}

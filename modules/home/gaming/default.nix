{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.homeManager.gaming.imports = with config.flake.modules.homeManager; [
    obs-studio

    lutris
    sober
    prism-launcher
  ];
}

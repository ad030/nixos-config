{
  self,
  inputs,
  config,
  ...
}:

{
  flake.modules.homeManager.apps.imports = with config.flake.modules.homeManager; [
    signal-desktop
    keepassxc
    vesktop
  ];
}

{
  self,
  inputs,
  config,
  ...
}:

{
  flake.modules.hm.apps.imports = with config.flake.modules.hm; [
    signal-desktop
    keepassxc
    vesktop
  ];
}

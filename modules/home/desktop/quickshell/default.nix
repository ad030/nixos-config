{
  self,
  inputs,
  ...
}:
let
  configFiles = builtins.attrNames (builtins.readDir ./_bar-config);
in
{
  flake.modules.homeManager.quickshell = {
    programs.quickshell = {
      enable = true;
    };

    xdg.configFile."quickshell" = {
      source = ./_bar-config;
      recursive = true;
    };

  };
}

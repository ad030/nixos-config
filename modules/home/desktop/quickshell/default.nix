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

      configs = map (f: /. + f) configFiles;
    };

  };
}

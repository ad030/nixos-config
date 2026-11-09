{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.quickshell = {
    programs.quickshell = {
      enable = true;
    };

    xdg.configFile."quickshell" = {
      source = inputs.quickshell-config;
      recursive = true;
    };

  };
}

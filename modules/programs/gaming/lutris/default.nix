{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.lutris = {
    programs.lutris = {
      enable = true;
    };
  };
}

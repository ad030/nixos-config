{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.noctalia =
    {
      pkgs,
      ...
    }:

    {
      programs.noctalia.settings = inputs.nixpkgs-unstable.builtins.parseJson (
        builtins.readFile ./noctalia.json
      );
    };
}

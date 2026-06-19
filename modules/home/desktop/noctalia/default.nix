{
  self,
  inputs,
  ...
}:
{
  flake.modules.hm.noctalia =
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

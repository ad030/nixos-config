## latex stuff
{
  flake.modules.homeManager.latex =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        texliveFull

        # biber
        python314Packages.pylatexenc
      ];
    };
}

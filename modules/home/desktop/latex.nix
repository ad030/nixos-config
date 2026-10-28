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
        (texliveBasic.withPackages (ps: [ ps.latexmk ]))
        biber
        python314Packages.pylatexenc
      ];
    };
}

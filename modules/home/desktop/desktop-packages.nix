{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.desktop-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice # office suite
        kdePackages.okular # pdf viewer

        ani-cli # watch anime
        jellyfin-desktop # media server

        obsidian # notetaking
        freetube # youtube frontend

        # latex stuff
        (texliveBasic.withPackages (ps: [ ps.latexmk ]))
        biber
        python314Packages.pylatexenc
      ];
    };
}

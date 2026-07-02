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
        firefox # browser
        libreoffice # office suite
        kdePackages.okular # pdf viewer

        # password manager
        keepassxc

        # media
        ffmpeg
        imagemagick
        mpv
        vlc
        feh
        swayimg

        ani-cli # watch anime
        strawberry # music player
        jellyfin-desktop # access media server

        obsidian # notetaking
        freetube # youtube frontend

        # latex stuff
        (texliveBasic.withPackages (ps: [ ps.latexmk ]))
        biber
        python314Packages.pylatexenc

        gimp
        kdePackages.kdenlive
        krita
        aseprite
      ];
    };
}

{ config, ... }:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      audio

      niri
      waybar
      quickshell
      fuzzel
      foot

      keepassxc
      vesktop
      signal-desktop
    ];

    home.packages = with pkgs; [
      fastfetch

      firefox # browser
      libreoffice # office suite
      kdePackages.okular # pdf viewer

      # file manager that's better than dolphin
      pcmanfm-qt
      gvfs

      # password manager
      keepassxc

      # media
      ffmpeg
      imagemagick
      mpv
      vlc
      feh
      swayimg
      yt-dlp

      ani-cli # watch anime
      jellyfin-desktop # access media server

      strawberry # music player
      picard # music tagging

      obsidian # notetaking
      freetube # youtube frontend

      # latex stuff
      (texliveBasic.withPackages (ps: [ ps.latexmk ]))
      biber
      python314Packages.pylatexenc

      gimp
      kdePackages.kdenlive
      krita
      # aseprite

      puddletag
      zotero
      audacity
    ];
  };
}

{ config, ... }:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      audio

      foot
      niri
      waybar
      quickshell
      rofi
      # fuzzel

      keepassxc
      vesktop
      signal-desktop
      obs-studio
    ];

    home.packages = with pkgs; [
      fastfetch

      libreoffice # office suite
      kdePackages.okular # pdf viewer

      ## file manager that's better than dolphin
      # pcmanfm-qt
      nemo-with-extensions

      ## password manager
      keepassxc

      ## media
      ffmpeg
      imagemagick
      mpv
      vlc
      swayimg
      lxqt.lximage-qt
      yt-dlp

      simple-scan # scanner (for scanners implementing SANE interface)
      # NOTE: modern printers are compatible with CUPS
      # no specific tool necessary; should be automatically detected by client

      ## archive file utilities
      _7zip-zstd
      kdePackages.ark
      # file-roller

      ani-cli # watch anime
      jellyfin-desktop # access media server

      strawberry # music player
      feishin # music player (navidrome)
      picard # music tagging

      obsidian # notetaking
      freetube # youtube frontend

      ## latex stuff
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

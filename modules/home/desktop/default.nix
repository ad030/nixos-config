{ config, ... }:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      core

      audio

      foot
      niri
      waybar
      quickshell
      rofi
      # fuzzel

      latex

      keepassxc
      vesktop
      signal-desktop
      obs-studio
      yt-dlp
      picard
    ];

    home.packages = with pkgs; [
      fastfetch

      libreoffice # office suite
      kdePackages.okular # pdf viewer

      ## file manager that's better than dolphin
      # pcmanfm-qt

      ## password manager
      keepassxc

      ## media
      ffmpeg
      imagemagick
      mpv
      vlc
      swayimg
      lxqt.lximage-qt

      simple-scan # scanner (for scanners implementing SANE interface)
      # NOTE: modern printers are compatible with CUPS
      # no specific tool necessary; should be automatically detected by client

      ## archive file utilities
      _7zip-zstd
      file-roller

      ani-cli # watch anime
      jellyfin-desktop # access media server

      strawberry # music player
      feishin # music player (navidrome)

      obsidian # notetaking
      zettlr # notetaking
      freetube # youtube frontend

      puddletag
      zotero
      audacity

      sleek-todo # todo list

      spek # audio spectrum visualiser

      # zoom-us

      # calibre # ebook reader
    ];

    xdg.mimeApps.defaultApplications = {
      # "application/zip" = [ "org.kde.ark.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "x-scheme-handler/bitwarden" = [ "bitwarden.desktop" ];
      "x-scheme-handler/sgnl" = [ "signal.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal.desktop" ];
    };

  };
}

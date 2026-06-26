{
  flake.modules.nixos.desktop-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        firefox
        foot

        ffmpeg
        imagemagick
        mpv
        vlc
        feh

        fastfetch
      ];

    };
}

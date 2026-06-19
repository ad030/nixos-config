{
  flake.modules.nixos.desktop-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ffmpeg
        imagemagick
        mpv
        vlc
        feh

        fastfetch
      ];

    };
}

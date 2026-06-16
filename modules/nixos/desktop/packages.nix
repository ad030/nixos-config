{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ffmpeg
        imagemagick
        mpv
        vlc
      ];

    };
}

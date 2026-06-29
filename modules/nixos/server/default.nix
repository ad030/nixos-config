{
  config,
  ...
}:
{
  flake.modules.nixos.server = {
    imports = with config.flake.modules.nixos; [
      networking-server
      nfs-server
      reverse-proxy
      media-dirs
      sleep

      landing-page
      adguardhome
      jellyfin
      slskd
      qbittorrent
      calibre-web
    ];

  };
}

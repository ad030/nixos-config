{
  config,
  ...
}:
{
  flake.modules.nixos.server = {
    imports = with config.flake.modules.nixos; [
      server-packages
      networking-server
      nfs-server
      reverse-proxy
      media-dirs
      idle-server

      landing-page
      adguardhome
      freshrss
      jellyfin
      slskd
      qbittorrent
      calibre-web
      radarr
    ];

  };
}

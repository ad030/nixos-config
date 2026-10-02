{
  config,
  ...
}:
{
  flake.modules.nixos.containers = {
    imports = with config.flake.modules.nixos; [
      containers-core

      # containers-adguardhome # dns server
      containers-technitium # dns server

      # notifications
      containers-ntfy # notifications

      containers-freshrss
      containers-jellyfin
      containers-slskd
      containers-qbittorrent
      containers-calibre-web-automated
      containers-radarr
      containers-navidrome
      containers-sonarr
      containers-vaultwarden

      containers-kiwix-serve # local wikipedia

      # containers-aria2 # download manager
    ];
  };
}

{
  config,
  ...
}:
{
  flake.modules.nixos.server =
    {
      pkgs,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        domain-certs

        networking-server
        nfs-server
        reverse-proxy
        media-dirs
        idle-server
        containers-core

        landing-page

        ## DNS servers
        # adguardhome
        containers-technitium

        # notifications
        containers-ntfy

        containers-freshrss
        containers-jellyfin
        containers-slskd
        containers-qbittorrent
        containers-calibre-web-automated
        containers-radarr
        containers-navidrome
        containers-sonarr
        containers-vaultwarden

        # local wikipedia
        containers-kiwix-serve

        # download manager
        # aria2
      ];

      environment.systemPackages = with pkgs; [
        mkcert
        rsync
        ethtool
        iperf3
        smartmontools
        openssl
        ntp
      ];

      hardware.graphics.enable = true;
    };
}

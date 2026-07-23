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
        ssl-root-certs

        networking-server
        nfs-server
        reverse-proxy
        media-dirs
        idle-server

        landing-page

        tailscale

        ## DNS servers
        # adguardhome
        technitium

        freshrss
        jellyfin
        slskd
        qbittorrent
        calibre-web
        radarr
        navidrome
      ];

      environment.systemPackages = with pkgs; [
        mkcert
        rsync
        ethtool
        iperf3
        smartmontools
      ];
    };
}

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
        core

        domain-certs
        networking-server
        nfs-server
        reverse-proxy
        media-dirs
        idle-server
        landing-page
        fail2ban
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

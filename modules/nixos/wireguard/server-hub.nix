# server hub
{
  self,
  config,
  ...
}@top:
{
  flake.modules.nixos.wireguard-server-hub =
    {
      config,
      lib,
      ...
    }:
    let
      wg = top.config.flake.lib.wireguard;
      hostname = config.networking.hostName;
    in
    {
      imports = [ top.config.flake.modules.nixos.wireguard-common ];

      sops.secrets."wireguard/private-key" = {
        sopsFile = "${self}/secrets/wireguard/${hostname}.yaml";
        key = "private-key";
      };

      networking.firewall.allowedUDPPorts = [ wg.port ];

      # needed for clients to reach each other through hub
      # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

      networking.wireguard = {
        enable = true;
        interfaces = {
          wg0 = {
            ips = [ "${wg.hub.ip}/24" ];

            # WireGuard Port
            # Must be accessible by peers
            listenPort = wg.port;

            privateKeyFile = config.sops.secrets."wireguard/private-key".path;

            peers = lib.mapAttrsToList (_: c: {
              publicKey = c.publicKey;
              allowedIPs = [ "${c.ip}/32" ];
            }) wg.clients;
          };
        };
      };
    };
}

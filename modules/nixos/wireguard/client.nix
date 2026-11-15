# client
{
  self,
  config,
  ...
}@top:
{
  flake.modules.nixos.wireguard-client =
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
      sops.secrets."wireguard/private-keys/${hostname}" = {
        sopsFile = "${self}/secrets/wireguard.yaml";
      };

      networking.wireguard = {
        enable = true;
        interfaces = {
          wg0 = {
            # the IP address and subnet of this peer
            ips = [
              "${wg.clients.${hostname}.ip}/24"
            ];

            privateKeyFile = config.sops.secrets."wireguard/private-keys/${hostname}".path;

            peers = [
              {
                publicKey = wg.hub.publicKey;
                allowedIPs = [ wg.subnet ];
                endpoint = "${wg.endpoint}:${toString wg.port}";

                # Send keepalives every 25 seconds. Important to keep NAT tables alive.
                persistentKeepalive = 25;
                dynamicEndpointRefreshSeconds = 300;
              }
            ];
          };
        };
      };
    };
}

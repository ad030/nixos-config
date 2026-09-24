# shared wireguard config
{
  flake.wireguardPeers = {
    attlerock = {
      publicKey = "";
      tunnelIPs = [ "10.10.10.1" ];
      endpoint = "";
    };
    timber-hearth = {
      publicKey = "";
      tunnelIPs = [ "10.10.10.2" ];
      endpoint = null;
    };
  };

  flake.modules.nixos.wireguard =
    {
      config,
      ...
    }:
    {
      networking.firewall.allowedUDPPorts = [ 51820 ];

      networking.wireguard = {
        enable = true;
        interfaces.wg0.listenPort = 51820;
      };
    };
}

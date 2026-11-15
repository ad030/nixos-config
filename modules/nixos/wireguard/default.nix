# shared wireguard config
{
  flake.lib.wireguard = {
    subnet = "10.101.0.0/24";
    port = 51820;
    hub = "attlerock";

    peers = {
      attlerock = {
        publicKey = "";
        tunnelIPs = [ "10.101.0.1" ];
        endpoint = "";
      };
      timber-hearth = {
        publicKey = "";
        tunnelIPs = [ "10.101.0.2" ];
        endpoint = null;
      };
      brittle-hollow = {
        publicKey = "";
        tunnelIPs = [ "10.101.0.3" ];
        endpoint = null;
      };
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

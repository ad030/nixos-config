# shared wireguard data
{
  self,
  ...
}@top:
{
  flake.lib.wireguard = {
    subnet = "10.100.0.0/24";
    port = 51820;
    endpoint = "vpn.4384381.xyz";

    hub = {
      name = "attlerock";
      publicKey = "GChJD1ldH7+QlGMdixbuq3tp0wtEdInyzqiAUI6pBX4=";
      ip = "10.100.0.1";
    };

    clients = {
      timber-hearth = {
        publicKey = "MfczO2sBtEDyFIAU1fo+1bsOiG7m8sTW4cQN0Jb+4XA=";
        ip = "10.100.0.2";
      };
      brittle-hollow = {
        publicKey = "2lmEwMzdoOlXJAQao4dl7yGvj4CcDELY3XY7jM5YbWc=";
        ip = "10.100.0.3";
      };
      phone-s23 = {
        publicKey = "H8eernH23Y6yMerA7GZP+WhbeRYQHR+i3xRu2suB7j8=";
        ip = "10.100.0.4";
      };
    };
  };

  flake.modules.nixos.wireguard-common =
    {
      lib,
      ...
    }:
    let
      wg = top.config.flake.lib.wireguard;
    in
    {
      networking.hosts = {
        ${wg.hub.ip} = [ wg.hub.name ];
      }
      // lib.mapAttrs' (n: c: lib.nameValuePair c.ip [ n ]) wg.clients;
    };
}

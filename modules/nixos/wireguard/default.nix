# shared wireguard data
{
  flake.lib.wireguard = {
    subnet = "10.101.0.0/24";
    port = 51820;
    endpoint = "vpn.4384381.xyz";

    hub = {
      name = "attlerock";
      publicKey = "GChJD1ldH7+QlGMdixbuq3tp0wtEdInyzqiAUI6pBX4=";
      ip = "10.101.0.1";
    };

    clients = {
      timber-hearth = {
        publicKey = "MfczO2sBtEDyFIAU1fo+1bsOiG7m8sTW4cQN0Jb+4XA=";
        ip = "10.101.0.2";
      };
      brittle-hollow = {
        publicKey = "2lmEwMzdoOlXJAQao4dl7yGvj4CcDELY3XY7jM5YbWc=";
        ip = "10.101.0.3";
      };
    };
  };
}

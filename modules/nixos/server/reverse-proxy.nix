{
  self,
  ...
}:
{
  flake.modules.nixos.reverse-proxy = {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;

      # max amount of data allowed to be sent
      clientMaxBodySize = "100M";
    };

    networking.firewall = {
      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };
}

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

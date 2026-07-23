{
  flake.modules.nixos.reverse-proxy = {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
    };

    networking.firewall = {
      allowedTCPPorts = [
        22
        80
        443
      ];
    };

    security.pki.certificateFiles = [
      "/root/.local/share/mkcert/rootCA.pem"
    ];
  };
}

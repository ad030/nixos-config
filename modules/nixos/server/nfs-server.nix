{
  flake.modules.nixos.nfs-server = {
    services.nfs.server = {
      enable = true;
    };

    networking.firewall.allowedTCPPorts = [ 2049 ];
  };
}

{
  flake.modules.nixos.nfs-server = {
    services.nfs = {
      server = {
        enable = true;
      };
      settings = {
        mountd = {
          manage-gids = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      111
      2049
    ];

    systemd.tmpfiles.settings."nfs-server" = {
      "/export".d = {
        user = "nobody";
        group = "nogroup";
        mode = "0555";
      };
    };
  };
}

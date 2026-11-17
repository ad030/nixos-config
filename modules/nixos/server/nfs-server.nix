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

        nfsd = {
          vers3 = false;
          vers4 = true;
        };
      };
    };

    # open only for wireguard interface
    networking.firewall.interfaces = {
      wg0.allowedTCPPorts = [ 2049 ];
    };

    systemd.tmpfiles.settings."nfs-server" = {
      "/export".d = {
        user = "root";
        group = "root";
        mode = "0555";
      };
    };
  };
}

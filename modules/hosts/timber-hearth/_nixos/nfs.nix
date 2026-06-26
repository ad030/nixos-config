{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime,nofail,nfsvers=4";
        TimeoutSec = "5";
      };
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];
      # what = "192.168.8.201:/media-share";
      what = "192.168.8.201:/mnt/tank"; # have not switched server to nix yet; still using /mnt/tank
      where = "/mnt/media-share";
    }
  ];

  systemd.automounts = [
    {
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/mnt/media-share";
    }
  ];

}

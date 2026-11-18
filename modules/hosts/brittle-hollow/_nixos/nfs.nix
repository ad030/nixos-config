{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot.supportedFilesystems = [ "nfs" ];
  # services.rpcbind.enable = true;

  fileSystems."/mnt/tank" = {
    device = "10.100.0.1:/tank";
    fsType = "nfs";
    options = [
      "defaults"
      "noatime"
      "nofail"
      "nfsvers=4"

      "x-systemd.automount"
      "noauto"
    ];
  };
}

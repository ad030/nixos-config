{
  config,
  pkgs,
  lib,
  ...
}:

{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems = {
    "/mnt/media-share" = {
      device = "192.168.8.201:/mnt/tank";
      fsType = "nfs";
      options = [
        "exec"
        "nofail"
      ];
    };
  };
}

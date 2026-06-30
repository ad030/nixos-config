{
  fileSystems."/srv/media/tank" = {
    device = "tank";
    fsType = "zfs";
  };

  fileSystems."/srv/media/wd-blue-1tb" = {
    device = "/dev/disk/by-uuid/35EFA427397E8837";
    fsType = "ntfs3";
  };
}

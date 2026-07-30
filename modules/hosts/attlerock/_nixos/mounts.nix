{
  fileSystems."/srv/media/tank" = {
    device = "tank";
    fsType = "zfs";

    options = [
      "acltype=posixacl"
      "aclinherit=passthrough"
    ];
  };

  fileSystems."/srv/media/wd-blue-1tb" = {
    device = "/dev/disk/by-uuid/35EFA427397E8837";
    fsType = "ntfs3";
  };
}

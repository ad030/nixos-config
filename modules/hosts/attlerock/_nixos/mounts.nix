{
  fileSystems."/srv/media/wd-blue-1tb" = {
    device = "/dev/disk/by-uuid/35EFA427397E8837";
    deviceType = "ext4";
    options = [
      "defaults"
      "nofail"
      "exec"
    ];
  };
}

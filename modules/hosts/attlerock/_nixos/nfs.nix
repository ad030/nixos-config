{
  config,
  ...
}:
{
  services.nfs.server.enable = true;

  fileSystems."/export/tank" = {
    depends = [
      "/srv/media/tank"
    ];

    device = "/srv/media/tank";

    fsType = "none";
    options = [ "bind" ];
  };

  systemd.tmpfiles.rules = [
    "d /export/tank 2775 root media - -"
    "a /export/tank - - - - group:media:rwx"
    "a /export/tank - - - - default:group:media:rwx"
    "a /export/tank - - - - default:mask::rwx"
  ];

  services.nfs.server.exports = ''
    /export  192.168.8.0/24(ro,fsid=0,no_subtree_check)
    /export/tank 192.168.8.0/24(rw,nohide,no_subtree_check,root_squash)
  '';
}

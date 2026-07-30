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

  systemd.tmpfiles.settings."export-tank" = {
    "/export/tank" = {
      d = {
        user = "root"; 
        group = "media"; 
        mode = "2775"; 
      };
      # ensure media group gets rwx permissions
      "a+media-perms" = {
        type = "a";
        argument = "group:media:rwx";
      };
      # set default permissions for new files (owner, group, other)
      "a+user-perms" = {
        type = "a";
        argument = "default:user::rwx";
      };
      "a+group-perms" = {
        type = "a";
        argument = "default:group:media:rwx";
      };
      "a+other-perms" = {
        type = "a";
        argument = "default:other::rwx";
      };
      # set default acl mask
      "a+default-mask" = {
        type = "a";
        argument = "default:mask::rwx";
      };
  };

  services.nfs.server.exports = ''
    /export  192.168.8.0/24(ro,fsid=0,no_subtree_check)
    /export/tank 192.168.8.0/24(rw,nohide,no_subtree_check,root_squash)
  '';
}

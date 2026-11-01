{
  flake.modules.nixos.backup-dirs = {
    # create directory where backups will go into
    systemd.tmpfiles.settings."homelab-backup-dirs" = {
      "/srv/backup" = {
        d = {
          user = "root";
          group = "media";
          mode = "2775";
        };
        # ensure media group gets rwx permissions
        "a+media-perms" = {
          type = "a+";
          argument = "group:media:rwX,default:group:media:rwX";
        };
        # acl default permissions
        "a+default-perms" = {
          type = "a+";
          argument = "d:user::rwX,d:group::rwX,d:other:r-X";
        };
      };
    };
  };
}

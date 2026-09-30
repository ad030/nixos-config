{
  flake.modules.nixos.media-dirs = {
    # create directories where media is mounted at
    systemd.tmpfiles.settings."homelab-media-dirs" = {
      "/srv/downloads" = {
        d = {
          user = "root";
          group = "root";
          mode = "2755";
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
      "/srv/media" = {
        d = {
          user = "root";
          group = "root";
          mode = "2755";
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

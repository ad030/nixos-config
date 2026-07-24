{
  # ids that need to be constant across systems
  # e.g. for NFS manage-gids
  flake.lib.sharedIds = {
    users = {
      solanum = {
        uid = 1000;
        groups = [ "media" ];
      };
      chert = {
        uid = 1001;
        groups = [ "media" ];
      };
    };

    groups = {
      media = {
        gid = 3333;
      };
      render = {
        gid = 303;
      };
      video = {
        gid = 26;
      };
    };
  };
}

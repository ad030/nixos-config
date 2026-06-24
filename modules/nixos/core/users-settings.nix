{
  flake.modules.nixos.users-settings = {
    users.mutableUsers = false;

    # create user and group for use in shared media directories (nfs)
    users.users.media = {
      uid = 3333;
      group = "media";
      isNormalUser = true;
    };
    users.groups.media.gid = 3333;
  };
}

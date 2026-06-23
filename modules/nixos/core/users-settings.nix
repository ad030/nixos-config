{
  flake.modules.nixos.users-settings = {
    users.mutableUsers = false;

    # create group for shared media directories (nfs)
    users.groups.media.gid = 3333;
  };
}

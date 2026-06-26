{
  flake.modules.nixos.users-settings = {
    users.mutableUsers = false;

    # root user only for emergency logins (if i mess up sops-nix and passwords are disabled)
    users.users.root.hashedPassword = "$y$j9T$KPQS8q1qZ8.HR5rtnT33N0$jlOkZFzUl4tWpKXBzreJcbe7cQW1E0JPL9.2uOKp0u.";

    # create user and group for use in shared media directories (nfs)
    users.users.media = {
      uid = 3333;
      group = "media";
      isNormalUser = true;
    };
    users.groups.media.gid = 3333;
  };
}

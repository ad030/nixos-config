{
  flake.modules.nixos.users-settings = {
    users.mutableUsers = false;

    # root user only for emergency logins
    # and ssh to rebuild systems
    users.users.root = {
      hashedPassword = "$y$j9T$KPQS8q1qZ8.HR5rtnT33N0$jlOkZFzUl4tWpKXBzreJcbe7cQW1E0JPL9.2uOKp0u.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOToXINio9+fZSsAW3/YmgioP+7RLFXwEZNJRWRQMZjl solanum@brittle-hollow"
      ];
    };

    # create group for use in shared media directories (nfs)
    users.groups.media.gid = 3333;
  };
}

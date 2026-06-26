{
  flake.modules.nixos.users-settings = {
    users.mutableUsers = false;

    # root user only for emergency logins (if i mess up sops-nix and passwords are disabled)
    users.users.root.hashedPassword = "$y$j9T$G8vUPuF8xgGGP8Y/CbP9x.$jzOR575KBP/R/PT9baCSmvRuqzhQw3rb88xKTijHkF8";

    # create user and group for use in shared media directories (nfs)
    users.users.media = {
      uid = 3333;
      group = "media";
      isNormalUser = true;
    };
    users.groups.media.gid = 3333;
  };
}

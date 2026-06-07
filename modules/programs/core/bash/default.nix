{
  flake.modules.homeManager.bash =

    { ... }:
    let
      nixos_config_dir = "~/nixos";
    in
    {
      programs.bash = {
        enable = true;
        enableCompletion = true;

        # profileExtra = ''
        #   eval $(/run/wrappers/bin/gnome-keyring-daemon --start --daemonize)
        #   export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh";
        # '';

        shellAliases = {
          # make file commands interactive
          rm = "rm -iv";
          cp = "cp -iv";
          mv = "mv -iv";

          # for listing directory contents
          l = "ls -alh";
          ll = "ls -l";
          ls = "ls --color=tty";

          # for reloading nixos config using flake
          nrs = "sudo nixos-rebuild switch --flake ${nixos_config_dir}";
        };

      };
    };
}

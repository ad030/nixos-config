{ ... }:
let 
  nixos_flake_dir = "~/nixos";
in
{
  programs.bash = {
    enable = true;
    shellAliases = {
      # make file commands interactive
      rm = "rm -iv";
      cp = "cp -iv";
      mv = "mv -iv";

      # for listing directory contents
      l="ls -alh";
      ll="ls -l";
      ls="ls --color=tty";

      # for reloading nixos config using flake
      # needs impure because hardware-configuration.nix is in /etc/nixos
      nrs = "sudo nixos-rebuild switch --impure --flake ${nixos_flake_dir}";
    };
  };
}

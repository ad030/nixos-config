{ ... }:
let 
  nixos_config_file = "~/nixos-config/configuration.nix";
in
{
  programs = {
    bash = 
    {
      enable = true;
      shellAliases = 
      {
              # make file commands interactive
              rm = "rm -i";
              cp = "cp -i";
              mv = "mv -i";

              # for listing directory contents
              l="ls -alh";
              ll="ls -l";
              ls="ls --color=tty";

              # for reloading nixos config
              nrs = "sudo nixos-rebuild switch --file ${nixos_config_file}";
      };
    };
  };
}

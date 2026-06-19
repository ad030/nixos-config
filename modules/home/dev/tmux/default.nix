{ self, inputs, ... }:
{
  flake.modules.hm.tmux =
    { pkgs, ... }:

    {
      programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
      };
    };
}

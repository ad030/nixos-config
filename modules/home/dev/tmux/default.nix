{ self, inputs, ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:

    {
      programs.tmux = {
        enable = true;
        clock24 = true;
        keyMode = "vi";
      };
    };
}

{ self, inputs, ... }:
{

  flake.modules.homeManager.tmux =
    { pkgs, ... }:

    {
      programs.tmux = {
        clock24 = true;
        keyMode = "vi";
      };
    };
}

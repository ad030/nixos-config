{ pkgs, inputs, ... }:

{
  programs.tmux = {
    clock24 = true;
    keyMode = "vi";
  };
}

{ pkgs, inputs, ... }:

{
  programs.tmux = {
    enable = true;

    clock24 = true;
  };
}

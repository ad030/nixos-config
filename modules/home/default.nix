{ self, inputs, ... }:

{
  imports = [
    inputs.home-manager.flakeModules.home-manager
    ./foot
    ./bash

    ./neovim
    ./tmux

    ./sway
    ./waybar
    ./rofi
    ./fuzzel
    # ./vicinae

    ./niri

    ./signal
    ./keepassxc
  ];
}

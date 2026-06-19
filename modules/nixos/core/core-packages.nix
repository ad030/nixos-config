{
  flake.modules.nixos.core-packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
        wget
        curl
        git
        bash
        python314
        jq
        htop

        # used for secrets backend
        keepassxc

        # notifications
        libnotify
        mako

        # audio
        pavucontrol
        pamixer
        wireplumber

        # bluetooth
        bluez
        bluez-tools

        # nix programming; language server, formatter
        nil
        nixfmt
      ];
    };
}

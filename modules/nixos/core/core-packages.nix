{
  flake.modules.nixos.core-packages =
    { pkgs, ... }:
    {
      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;
        };
      };

      environment.systemPackages = with pkgs; [
        neovim
        wget
        curl
        git
        bash
        python314
        jq
        htop

        # notifications
        libnotify
        mako

        # nix programming; language server, formatter
        nil
        nixfmt
      ];
    };
}

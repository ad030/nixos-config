{
  flake.modules.nixos.fonts =
    {
      config,
      pkgs,
      ...
    }:

    {
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji

        open-sans

        # nerd fonts
        nerd-fonts.noto
        nerd-fonts.fira-mono
        nerd-fonts.meslo-lg

        # icon fonts
        material-symbols
        # font-awesome_4
        # font-awesome_5
        # font-awesome_6
      ];
    };
}

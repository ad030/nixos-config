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

    font-awesome_4
    font-awesome_5
    font-awesome_6

    # nerd fonts
    nerd-fonts.fira-mono
    nerd-fonts.meslo-lg
  ];

}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.desktop-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice
        kdePackages.okular
        ani-cli
        jellyfin-desktop
      ];
    };
}

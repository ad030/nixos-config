{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.desktop =
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

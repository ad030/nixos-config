{
  self,
  inputs,
  ...
}:
{
  flake.modules.hm.desktop =
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

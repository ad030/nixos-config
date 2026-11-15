{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.plasma-oxygen = { pkgs, ... }: {
    imports = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    home.packages = [
      pkgs.kdePackages.oxygen
      pkgs.kdePackages.oxygen-icons
      pkgs.kdePackages.oxygen-sounds
    ];

    programs.plasma = {
      enable = true;
      workspace = {
        lookAndFeel = "org.kde.oxygen";
      };
    };
  };
}

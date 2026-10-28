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

    home.packages = with pkgs.kdePackages; [
      oxygen
      oxygen-icons
      oxygen-sounds
    ];

    programs.plasma = {
      enable = true;
      workspace = {
        lookAndFeel = "org.kde.oxygen";
      };
    };
  };
}

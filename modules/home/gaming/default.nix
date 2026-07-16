{
  self,
  inputs,
  config,
  ...
}:
{
  flake.modules.homeManager.gaming = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      lutris
      sober
    ];

    home.packages = with pkgs; [
      # osu-lazer
      heroic # linux native launcher for epic games
      prismlauncher # minecraft launcher
      owmods-gui # outer wilds mod launcher gui
    ];
  };
}

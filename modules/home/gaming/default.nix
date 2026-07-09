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
      osu-lazer
      heroic
      prismlauncher
    ];
  };
}

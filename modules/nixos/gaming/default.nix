{
  config,
  ...
}:
{
  flake.modules.nixos.gaming = { pkgs, ... }: {
    imports = with config.flake.modules.nixos; [
      steam
    ];

    environment.systemPackages = with pkgs; [
      # osu-lazer
      legendary-gl # for epic games
      rare # gui for legendary
      heroic # for gog
      prismlauncher # minecraft launcher
      owmods-gui # outer wilds mod launcher gui
    ];
  };
}

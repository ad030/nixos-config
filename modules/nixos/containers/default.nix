{
  config,
  ...
}:
{
  flake.modules.nixos.containers = {
    imports = with config.flake.modules.nixos; [
      core
    ];

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}

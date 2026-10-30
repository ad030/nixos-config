{
  config,
  ...
}:
{
  flake.modules.nixos.containers = {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}

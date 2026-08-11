{
  flake.modules.nixos.timesyncd = {
    services.timesyncd.enable = true;
  };
}

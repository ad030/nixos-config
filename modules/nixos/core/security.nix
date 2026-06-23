{
  flake.modules.nixos.security = {
    security = {
      rtkit.enable = true;
    };
  };
}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.reverse-proxy = {
    services.nginx = {
      enable = true;
    };
  };
}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.hm.core = {
    nix = {
      settings.experimental-features = [
        # enable nix flakes
        "nix-command"
        "flakes"
      ];
    };
  };
}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.nix = {
    nix = {
      settings.experimental-features = [
        # enable nix flakes
        "nix-command"
        "flakes"
      ];
    };
  };
}

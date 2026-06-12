{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) types mkOption;
in
{
  options.flake.homeUsers = mkOption {
    type = types.attrsOf types.unspecified;
    default = { };
  };
}

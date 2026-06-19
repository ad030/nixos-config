# define flake option for tracking home manager users
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
  options.flake.hmUsers = mkOption {
    type = with types; attrsOf deferredModule;
    default = { };
  };
}

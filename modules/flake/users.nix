# define flake options for tracking users
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
  # home manager: for user specific configs
  options.flake.hmUsers = mkOption {
    type = with types; attrsOf deferredModule;
    default = { };
  };

  # nixos: use flake.modules.nixos."users-${username}" to store nixos module
}

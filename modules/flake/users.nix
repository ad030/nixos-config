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

  # nixos: for the system itself to determine which users are on a system
  options.flake.nixosUsers = mkOption {
    type =
      with types;
      attrsOf (submodule {
        options = {
          isNormalUser = mkOption {
            type = bool;
            default = true;
          };
          extraGroups = mkOption {
            type = listOf str;
            default = [ ];
          };
          hashedPassword = mkOption {
            type = str;
            default = "";
          };
          description = mkOption {
            type = str;
            default = "";
          };
          shell = mkOption {
            type = shellPackage;
            default = pkgs.bash;
          };
        };
      });
    default = { };
  };
}

# define flake.lib option to store raw values in
{
  lib,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
  };
}

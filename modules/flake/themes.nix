# define flake.themes option to store themes in
{
  lib,
  ...
}:
{
  options.flake.themes = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
  };
}

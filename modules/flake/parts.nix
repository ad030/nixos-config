{ inputs, ... }:
{
  imports = [
    # enable optional flake.modules behaviour
    inputs.flake-parts.flakeModules.modules
  ];
}

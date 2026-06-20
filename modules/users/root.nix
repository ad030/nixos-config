{
  self,
  inputs,
  ...
}:
let
  username = "root";
in
{
  flake.modules.nixos."users-${username}" = {
    hashedPassword = "!"; # disable root login
  };
}

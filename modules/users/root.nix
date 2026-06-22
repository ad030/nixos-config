# root user which won't be used

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

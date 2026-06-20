{
  self,
  inputs,
  ...
}:
let
  username = "root";
in
{
  flake.nixosUsers.${username} = {
    hashedPassword = "!"; # disable root login
  };
}

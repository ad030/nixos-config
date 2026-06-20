{
  self,
  inputs,
  config,
  ...
}:
let
  username = "esker";
in
{
  flake.modules.nixos."users-${username}" =
    { pkgs, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPassword = ""; # TODO: add yescrypt hashed password later
      };
    };

  # server user doesn't need home manager
  flake.hmUsers.${username} = { };
}

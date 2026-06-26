# user for server machines

{
  self,
  inputs,
  ...
}:
let
  username = "esker";
in
{
  flake.modules.nixos."users-${username}" =
    { config, pkgs, ... }:
    {
      sops.secrets."passwords/${username}".neededForUsers = true;

      users.users.${username} = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
      };
    };

  # server user doesn't need home manager
  flake.hmUsers.${username} = { };
}

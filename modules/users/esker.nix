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
          "media"
        ];
        hashedPasswordFile = config.sops.secrets."passwords/${username}".path;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOToXINio9+fZSsAW3/YmgioP+7RLFXwEZNJRWRQMZjl solanum@brittle-hollow"
        ];
      };
    };

  # server user doesn't need home manager
  flake.hmUsers.${username} = { };
}

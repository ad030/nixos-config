{
  self,
  inputs,
}:
let
  username = "CHANGE_ME";
in
{
  flake.modules.nixos."users-${username}" =
    { config, pkgs, ... }:
    {
      # use sops for user password
      config.sops.secrets.passwords.${username}.neededForUsers = true;

      users.users.${username} = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [ ];
        hashedPasswordFile = config.sops.secrets.passwords.${username}.path;
      };
    };

  flake.hmUsers.${username} =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with self.modules.homeManager; [
        core
      ];

      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = "26.05";

        packages = with pkgs; [ ];
      };
    };
}

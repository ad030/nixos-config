{
  self,
  inputs,
  config,
  ...
}:
let
  username = "CHANGE_ME";
in
{
  flake.modules.nixos."users-${username}" =
    { pkgs, ... }:
    {
      users.users.${username} = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [ ];
        hashedPassword = "";
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

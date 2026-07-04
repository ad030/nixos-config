{
  self,
  inputs,
}:
let
  username = "CHANGE_ME";
in
{
  flake.modules.nixos."users-${username}" =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # use sops for user password
      sops.secrets."passwords/${username}".neededForUsers = true;

      users.users.${username} =
        let
          uid = self.lib.sharedIds.users.${username}.uid;
          groups = self.lib.sharedIds.users.${username}.groups;
        in
        {
          inherit uid;
          isNormalUser = true;
          shell = pkgs.bash;
          extraGroups = lib.uniqueStrings [ ] ++ groups;
          hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
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

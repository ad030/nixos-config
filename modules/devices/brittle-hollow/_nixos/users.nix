# home manager stuff is imported in <hostname>/default.nix

{
  config,
  pkgs,
  ...
}:

{
  users = {
    mutableUsers = false;

    users = {
      root = {
        # disable root login
        hashedPassword = "!";
      };
      nixuser = {
        isNormalUser = true;
        shell = pkgs.bash;
        description = "nixuser";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        hashedPassword = "$y$j9T$avB97rOQS/qFTosBcYu/w.$1cDcc.hv8V69alJB1vdQ3hGrKIPlJtw.3/OWJPl0Ow9";
      };
    };
  };
}

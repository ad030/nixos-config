{
  inputs,
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
      ad030 = {
        isNormalUser = true;
        shell = pkgs.bash;
        description = "ad030";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = [
          #  pkgs.thunderbird
        ];
        hashedPassword = "$y$j9T$avB97rOQS/qFTosBcYu/w.$1cDcc.hv8V69alJB1vdQ3hGrKIPlJtw.3/OWJPl0Ow9";
      };
    };
  };
}

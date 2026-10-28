{
  flake.modules.homeManager.tools-databases =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        sqlite
      ];
    };
}

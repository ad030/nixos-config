{
  flake.modules.homeManager.tools-documentation =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        doxygen
      ];
    };
}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.prism-launcher =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        prismlauncher
      ];
    };
}

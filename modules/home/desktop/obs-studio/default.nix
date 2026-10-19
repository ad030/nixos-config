{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.obs-studio = { pkgs, ... }: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
      ];
    };
  };
}

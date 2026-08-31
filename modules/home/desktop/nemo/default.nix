{
  flake.modules.homeManager.nemo = { pkgs, ... }: {
    home.packages = with pkgs; [
      nemo-with-extensions
    ];

    dconf = {
      settings = {
        "org/cinnamon/desktop/applications/terminal" = {
          exec = "foot";
          # exec-arg = ""; # argument
        };
      };
    };
  };
}

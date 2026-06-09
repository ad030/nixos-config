{
  config,
  pkgs,
  ...
}:

{
  services.displayManager = {
    ly = {
      enable = true;
      settings = {
        numlock = false;
        bigclock = "en";
        vimode = true;
      };
    };
  };

}

{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.niri = {
    programs.niri.settings = {
      workspaces = {
        scratchpad = {
          name = "S";
        };
      };

      window-rules = [
        {
          matches = [
            { app-id = "org.keepassxc.KeePassXC"; }
            { app-id = "org.strawberrymusicplayer.strawberry"; }
          ];
          open-on-workspace = "scratchpad";
        }
      ];
    };
  };
}

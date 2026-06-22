{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.niri = {
    programs.niri.settings = {

      ## I can live without a scratchpad probably
      # workspaces = {
      #   scratchpad = {
      #     name = "S";
      #   };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      #   "1" = { };
      # };
      #
      # window-rules = [
      #   {
      #     matches = [
      #       { app-id = "org.keepassxc.KeePassXC"; }
      #       { app-id = "org.strawberrymusicplayer.strawberry"; }
      #     ];
      #     open-on-workspace = "scratchpad";
      #   }
      # ];
    };
  };
}

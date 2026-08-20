{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.niri =
    let
      theme = self.themes.gruvbox-dark.niri;
    in
    {
      programs.niri.settings = {
        prefer-no-csd = true;

        layout = {
          gaps = 2;

          border = {
            enable = true;
            width = 1;
            inherit (theme.border) active inactive urgent;
          };

          default-column-width.proportion = 0.66;

          focus-ring = {
            enable = false;
            width = 2;
            inherit (theme.focus-ring) active inactive urgent;
          };
        };

      };
    };
}

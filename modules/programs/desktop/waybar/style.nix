{ self, inputs, ... }:
{
  flake.modules.homeManager.waybar =
    let
      theme = self.themes.gruvbox-dark;
    in
    {
      programs.waybar.style = ''
        * {
          border-radius: 0;
          font-family: MesloLGM Nerd Font;
          color: ${theme.palette.light1};
          font-size: 16px;
        }

        window#waybar {
          background-color: ${theme.palette.dark1};
          color: ${theme.palette.light1};
        }

        #clock,
        #battery,
        #cpu,
        #workspaces,
        #scratchpad,
        #memory,
        #backlight,
        #wireplumber,
        #network {
          background-color: ${theme.palette.dark1};
          color: ${theme.palette.light1};
          margin: 0 2px;
        }

        tooltip {
          background-color: ${theme.palette.dark1};
          border: 1px solid ${theme.palette.light1};
        }

        button:hover {
          box-shadow: none;
          text-shadow: none;
          border-color: transparent;
          background: none;
          transition: none;
        }

        #workspaces button {
          padding: 0 8px;
        }

        #workspaces button.focused {
          background-color: ${theme.palette.dark4};
          box-shadow: inset 0 -2px ${theme.palette.light1};
        }
      '';
    };
}

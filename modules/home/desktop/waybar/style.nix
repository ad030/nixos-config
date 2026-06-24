{ self, inputs, ... }:
{
  flake.modules.homeManager.waybar =
    let
      theme = self.themes.gruvbox-dark;
      alpha = "1.00";
    in
    {
      programs.waybar.style = ''
        * {
          border-radius: 0;
          font-family: "MesloLGM Nerd Font", "Font Awesome 5 Free";
          color: ${theme.palette.light1};
          font-size: 16px;
        }

        window#waybar {
          background-color: transparent;
          color: ${theme.palette.light1};
        }

        #clock,
        #battery,
        #cpu,
        #mpris,
        #workspaces,
        #scratchpad,
        #memory,
        #backlight,
        #idle_inhibitor,
        #wireplumber,
        #network {
          background-color: alpha(${theme.palette.dark1}, ${alpha});
          color: ${theme.palette.light1};
          margin: 2px;
          padding: 4px 12px;
          border: 1px solid ${theme.palette.light1};
        }

        tooltip {
          background-color: alpha(${theme.palette.dark1}, ${alpha});
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
          margin: 0 2px;
        }

        #workspaces button.focused {
          background-color: alpha(${theme.palette.dark4}, ${alpha});
        }
      '';
    };
  # box-shadow: inset 0 -2px ${theme.palette.light1};
}

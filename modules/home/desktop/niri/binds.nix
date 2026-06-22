{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.niri = { pkgs, lib, ... }: {
    programs.niri.settings = {
      binds = {
        "Mod+Return" = {
          action.spawn = "${lib.getExe pkgs.foot}";
          hotkey-overlay = {
            title = "Open terminal";
          };
        };
        "Mod+Shift+E" = {
          action.quit.skip-confirmation = false;
          hotkey-overlay.title = "Quit Niri";
        };
        "Mod+Shift+Q" = {
          action.close-window = [ ];
          hotkey-overlay.title = "Close focused window";
        };
        "Mod+D" = {
          action.spawn = "${lib.getExe pkgs.fuzzel}";
          hotkey-overlay.title = "Open launcher";
        };

        "Mod+F" = {
          # action.maximize-window-to-edges = [ ];
          action.maximize-column = [ ];
        };

        "Mod+Shift+F" = {
          action.fullscreen-window = [ ];
        };

        "Mod+Shift+S" = {
          action.spawn-sh = [ "wl-screenshot" ];
        };

        # "Print" = {
        #   action.screenshot = [ "show-pointer=false" ];
        # };
        # "Ctrl+Print" = {
        #   action.screenshot-screen = [ "show-pointer=false" ];
        # };
        # "Alt+Print" = {
        #   action.screenshot-window = [ "show-pointer=true" ];
        # };

        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

        "Mod+O".action.toggle-overview = [ ];
        "Mod+C".action.center-column = [ ];
        "Mod+W".action.toggle-column-tabbed-display = [ ];

        "Mod+H".action.focus-column-left = [ ];
        "Mod+J".action.focus-window-or-workspace-down = [ ];
        "Mod+K".action.focus-window-or-workspace-up = [ ];
        "Mod+L".action.focus-column-right = [ ];

        "Mod+Shift+H".action.move-column-left = [ ];
        "Mod+Shift+J".action.move-window-down-or-to-workspace-down = [ ];
        "Mod+Shift+K".action.move-window-up-or-to-workspace-up = [ ];
        "Mod+Shift+L".action.move-column-right = [ ];

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+0".action.focus-workspace = 10;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+Shift+0".action.move-column-to-workspace = 10;

        # scratchpad functionality
        "Mod+Minus" = {
          action.spawn-sh = "niri msg workspaces | grep \"\\*.*scratchpad\" && niri msg action focus-workspace-previous || niri msg action focus-workspace scratchpad";
        };
      };
    };
  };
}

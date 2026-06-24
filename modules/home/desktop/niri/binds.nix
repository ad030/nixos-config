{
  self,
  inputs,
  ...
}:
{
  flake.modules.homeManager.niri = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      playerctl
    ];

    programs.niri.settings = {
      binds = {
        "Mod+Return" = {
          action.spawn = [ "${lib.getExe' pkgs.foot "footclient"}" ];
          hotkey-overlay.title = "Open terminal";
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
          action.spawn = [ "${lib.getExe pkgs.fuzzel}" ];
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
          action.spawn = [ "wl-screenshot" ];
          hotkey-overlay.title = "Take screenshot";
        };

        "Mod+XF86MonBrightnessDown" = {
          action.spawn = [
            "${lib.getExe pkgs.brightnessctl}"
            "set"
            "4%-"
          ];
          hotkey-overlay.title = "Lower screen brightness";
        };

        # "Mod+F3" = {
        #   action.spawn = [
        #     "${lib.getExe pkgs.brightnessctl}"
        #     "set"
        #     "4%-"
        #   ];
        # };

        "Mod+XF86MonBrightnessUp" = {
          action.spawn = [
            "${lib.getExe pkgs.brightnessctl}"
            "set"
            "+4%"
          ];
          hotkey-overlay.title = "Raise screen brightness";
        };

        "Mod+XF86AudioMute" = {
          action.spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-mute"
            "@DEFAULT_AUDIO_SINK@"
            "toggle"
          ];
          hotkey-overlay.title = "Mute audio";
        };

        "Mod+XF86AudioRaiseVolume" = {
          action.spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "4%+"
          ];
          hotkey-overlay.title = "Raise volume";
        };
        "Mod+XF86AudioLowerVolume" = {
          action.spawn = [
            "${lib.getExe' pkgs.wireplumber "wpctl"}"
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "4%-"
          ];
          hotkey-overlay.title = "Lower volume";
        };

        "Mod+XF86AudioPrev" = {
          action.spawn = [
            "${lib.getExe pkgs.playerctl}"
            "previous"
          ];
          hotkey-overlay.title = "Play previous song";
        };

        "Mod+XF86AudioPlay" = {
          action.spawn = [
            "${lib.getExe pkgs.playerctl}"
            "play-pause"
          ];
          hotkey-overlay.title = "Play/pause current song";
        };

        "Mod+XF86AudioNext" = {
          action.spawn = [
            "${lib.getExe pkgs.playerctl}"
            "next"
          ];
          hotkey-overlay.title = "Play next song";
        };

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

        "Mod+Shift+1".action.move-window-to-workspace = 1;
        "Mod+Shift+2".action.move-window-to-workspace = 2;
        "Mod+Shift+3".action.move-window-to-workspace = 3;
        "Mod+Shift+4".action.move-window-to-workspace = 4;
        "Mod+Shift+5".action.move-window-to-workspace = 5;
        "Mod+Shift+6".action.move-window-to-workspace = 6;
        "Mod+Shift+7".action.move-window-to-workspace = 7;
        "Mod+Shift+8".action.move-window-to-workspace = 8;
        "Mod+Shift+9".action.move-window-to-workspace = 9;
        "Mod+Shift+0".action.move-window-to-workspace = 10;
      };
    };
  };
}

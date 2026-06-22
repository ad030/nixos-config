{
  pkgs,
  lib,
  ...
}:
let
  mod = "SUPER";
  launcher_bin = lib.getExe pkgs.fuzzel;
  term_bin = lib.getExe pkgs.foot;

  mkBind =
    {
      keys,
      dispatcher,
      flags ? "",
    }:
    "hl.bind('${keys}', ${dispatcher}, {${flags}})";
  dsp = command: args: "hl.dsp.${command}(${args})";
in
lib.strings.concatMapStringsSep "\n" mkBind [
  {
    keys = "${mod} + D";
    dispatcher = dsp "exec_cmd" "'${launcher_bin}'";
  }
  {
    keys = "${mod} + ENTER";
    dispatcher = dsp "exec_cmd" "'${term_bin}'";
  }
  {
    keys = "${mod} + SHIFT + S";
    dispatcher = dsp "exec_cmd" "'wl-screenshot'";
  }
  {
    keys = "${mod} + SHIFT + Q";
    dispatcher = dsp "window.close" "";
  }
  {
    keys = "${mod} + SHIFT + E";
    dispatcher = dsp "exec_cmd" ''"command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"'';
  }

  {
    keys = "${mod} + XF86MonBrightnessDown";
    dispatcher = dsp "exec_cmd" "'${lib.getExe pkgs.brightnessctl} set 4%-'";
  }
  {
    keys = "${mod} + XF86MonBrightnessUp";
    dispatcher = dsp "exec_cmd" "'${lib.getExe pkgs.brightnessctl} set +4%'";
  }

  {
    keys = "${mod} + XF86AudioMute";
    dispatcher = dsp "exec_cmd" "'${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'";
  }
  {
    keys = "${mod} + XF86AudioRaiseVolume";
    dispatcher = dsp "exec_cmd" "'${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%+'";
  }
  {
    keys = "${mod} + XF86AudioLowerVolume";
    dispatcher = dsp "exec_cmd" "'${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 4%-'";
  }

  {
    keys = "${mod} + 1";
    dispatcher = dsp "focus" "{workspace = 1}";
  }
  {
    keys = "${mod} + 2";
    dispatcher = dsp "focus" "{workspace = 2}";
  }
  {
    keys = "${mod} + 3";
    dispatcher = dsp "focus" "{workspace = 3}";
  }
  {
    keys = "${mod} + 4";
    dispatcher = dsp "focus" "{workspace = 4}";
  }
  {
    keys = "${mod} + 5";
    dispatcher = dsp "focus" "{workspace = 5}";
  }
  {
    keys = "${mod} + 6";
    dispatcher = dsp "focus" "{workspace = 6}";
  }
  {
    keys = "${mod} + 7";
    dispatcher = dsp "focus" "{workspace = 7}";
  }
  {
    keys = "${mod} + 8";
    dispatcher = dsp "focus" "{workspace = 8}";
  }
  {
    keys = "${mod} + 9";
    dispatcher = dsp "focus" "{workspace = 9}";
  }
  {
    keys = "${mod} + 0";
    dispatcher = dsp "focus" "{workspace = 10}";
  }

  {
    keys = "${mod} + SHIFT + 1";
    dispatcher = dsp "window.move" "{workspace = 1}";
  }
  {
    keys = "${mod} + SHIFT + 2";
    dispatcher = dsp "window.move" "{workspace = 2}";
  }
  {
    keys = "${mod} + SHIFT + 3";
    dispatcher = dsp "window.move" "{workspace = 3}";
  }
  {
    keys = "${mod} + SHIFT + 4";
    dispatcher = dsp "window.move" "{workspace = 4}";
  }
  {
    keys = "${mod} + SHIFT + 5";
    dispatcher = dsp "window.move" "{workspace = 5}";
  }
  {
    keys = "${mod} + SHIFT + 6";
    dispatcher = dsp "window.move" "{workspace = 6}";
  }
  {
    keys = "${mod} + SHIFT + 7";
    dispatcher = dsp "window.move" "{workspace = 7}";
  }
  {
    keys = "${mod} + SHIFT + 8";
    dispatcher = dsp "window.move" "{workspace = 8}";
  }
  {
    keys = "${mod} + SHIFT + 9";
    dispatcher = dsp "window.move" "{workspace = 9}";
  }
  {
    keys = "${mod} + SHIFT + 0";
    dispatcher = dsp "window.move" "{workspace = 10}";
  }
  {
    keys = "${mod} + minus";
    dispatcher = dsp "workspace.toggle_special" "'scratchpad'";
  }
  {
    keys = "${mod} + SHIFT + minus";
    dispatcher = dsp "workspace.toggle_special" "'scratchpad'";
  }
  {
    keys = "${mod} + F";
    dispatcher = dsp "workspace.toggle_special" "'scratchpad'";
  }
  {
    keys = "${mod} + mouse:272";
    dispatcher = dsp "window.drag" "";
    flags = "mouse = true";
  }
  {
    keys = "${mod} + mouse:273";
    dispatcher = dsp "window.resize" "";
    flags = "mouse = true";
  }
]

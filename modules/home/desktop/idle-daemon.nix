{ self, inputs, ... }:
{
  flake.modules.homeManager.idle-daemon = { pkgs, lib, ... }: {

    programs = {
      hyprlock.enable = true;
      swaylock.enable = true;
    };

    services = {
      swayidle =
        let
          # lock = "${lib.getExe pkgs.swaylock} --daemonize";
          # display = status: "${lib.getExe' pkgs.sway "swaymsg"} 'output * power ${status}'";

          lock = "${lib.getExe pkgs.hyprlock} --grace 30";
          display = status: "${lib.getExe pkgs.niri} msg action 'power-${status}-monitors'";
        in
        {
          enable = true;
          timeouts = [
            {
              timeout = 540;
              command = "${lib.getExe' pkgs.libnotify "notify-send"} 'Locking in 60 seconds' -t 5000";
            }
            {
              timeout = 600;
              command = lock;
            }
            {
              timeout = 610;
              command = display "off";
              resumeCommand = display "on";
            }
          ];

          events = {
            before-sleep = (display "off") + "; " + lock;
            lock = (display "off") + "; " + lock;
            after-resume = display "on";
            unlock = display "on";
          };
        };
    }; # end services
  };
}

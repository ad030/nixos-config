{ pkgs, ... }: 

{
  home.packages = [ pkgs.signal-desktop ];

  xdg.desktopEntries = {
    signal = {
      categories = [
        # main category
        "Network"
        # additional categories
        "InstantMessaging"
        "Chat"
      ];

      # use gnome-libsecret for secrets backend
      exec = "signal-desktop --password-store=gnome-libsecret";
      genericName = "Private messaging app";

      name = "Signal";
      terminal = false;

    };
  };

}

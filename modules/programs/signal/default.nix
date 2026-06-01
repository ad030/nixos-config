{

  flake.modules.homeManager 
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

      # use specific secrets backend
      exec = "signal-desktop --password-store=gnome-libsecret";
      # exec = "signal-desktop --password-store=plaintext";

      name = "Signal";
      genericName = "Private messaging app";

      terminal = false;

    };
  };

};
}

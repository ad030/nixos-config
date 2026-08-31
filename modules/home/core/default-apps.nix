{
  flake.modules.homeManager.default-apps = {
    xdg.mimeApps.defaultApplications = {
      # "application/zip" = [ "org.kde.ark.desktop" ];
      "x-scheme-handler/bitwarden" = [ "bitwarden.desktop" ];
      "x-scheme-handler/sgnl" = [ "signal.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal.desktop" ];
    };
  };
}

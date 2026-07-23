{
  flake.modules.homeManager.default-apps = {
    xdg.mimeApps.defaultApplications = {
      "application/zip" = "org.kde.ark.desktop";
    };
  };
}

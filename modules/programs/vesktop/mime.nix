{
  flake.modules.homeManager."vesktop" = {
    xdg.mimeApps = {
      enable = true;
      defaultApplications."x-scheme-handler/discord" = ["vesktop.desktop"];
      associations.added."x-scheme-handler/discord" = ["vesktop.desktop"];
    };
  };
}

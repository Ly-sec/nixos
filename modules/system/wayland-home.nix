{
  homeManager.base = {
    config,
    lib,
    pkgs,
    ...
  }: let
    isPlasma = config.lysec.desktop == "plasma";
  in {
    home.sessionVariables =
      {
        ELECTRON_OZONE_PLATFORM_HINT = "x11";
      }
      // lib.optionalAttrs (!isPlasma) {
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORMTHEME = "gtk3";
      };

    home.packages = [pkgs.libnotify pkgs.wl-clipboard];
  };
}

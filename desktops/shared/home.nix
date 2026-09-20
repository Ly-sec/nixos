{
  config,
  lib,
  pkgs,
  ...
}:

let
  isPlasma = config.lysec.desktop == "plasma";
  noctalia = lib.getExe pkgs.noctalia;
in
{
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
  }
  // lib.optionalAttrs (!isPlasma) {
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  # Non-Plasma desktops; KDE uses desktops/plasma/home (starts after panel).
  xdg.configFile."autostart/noctalia.desktop" = lib.mkIf (!isPlasma) {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Noctalia
      Exec=${noctalia}
      X-GNOME-Autostart-enabled=true
      OnlyShowIn=GNOME;XFCE;Hyprland;niri;Umbriel;MangoWC;
    '';
  };
}

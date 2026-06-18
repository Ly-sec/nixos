{ vars, ... }:
{
  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  xdg.configFile."autostart/noctalia.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Noctalia
    Exec=${vars.noctalia}
    X-GNOME-Autostart-enabled=true
    OnlyShowIn=KDE;GNOME;XFCE;
  '';
}

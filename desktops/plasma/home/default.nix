# Noctalia dev on KDE — start after Plasma shell is up, not at compositor takeover.
{ vars, ... }:
{
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

  xdg.configFile."autostart/noctalia.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Noctalia
    Comment=Noctalia shell
    Exec=${vars.noctalia}
    X-GNOME-Autostart-enabled=true
    X-KDE-autostart-after=panel
    X-KDE-autostart-phase=2
    OnlyShowIn=KDE;
  '';
}

{ lib, config, ... }:

let
  noctalia = lib.getExe config.lysec.noctaliaPackage;
in
{
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

  xdg.configFile."autostart/noctalia.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Noctalia
    Comment=Noctalia shell
    Exec=${noctalia}
    X-GNOME-Autostart-enabled=true
    X-KDE-autostart-after=panel
    X-KDE-autostart-phase=2
    OnlyShowIn=KDE;
  '';
}

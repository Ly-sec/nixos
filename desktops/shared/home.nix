{ pkgs, vars, ... }:

let
  noctalia = import ../../lib/noctalia.nix { inherit pkgs vars; };
in
{
  home.packages = [
    noctalia.autostart
    noctalia.toggleLauncher
  ];

  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "x11";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    QT_QPA_PLATFORMTHEME = "gtk3";
  };

  # Fallback autostart for sessions without compositor-native startup (Plasma, Mango via dex).
  xdg.configFile."autostart/noctalia.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Noctalia
    Comment=Desktop shell
    Exec=${noctalia.autostart}/bin/noctalia-autostart
    X-GNOME-Autostart-enabled=true
    OnlyShowIn=KDE;GNOME;XFCE;
  '';
}

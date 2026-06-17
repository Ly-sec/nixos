{ pkgs, vars, ... }:

let
  noctalia = import ../../lib/noctalia.nix { inherit pkgs vars; };

  session = pkgs.writeShellScript "mangowc-session" ''
    export XDG_CURRENT_DESKTOP=MangoWC
    ${noctalia.autostart}/bin/noctalia-autostart &
    ${pkgs.dex}/bin/dex -a &
    exec ${pkgs.mangowc}/bin/mangowc "$@"
  '';
in
{
  environment.systemPackages = [
    pkgs.mangowc
    pkgs.dex
    noctalia.autostart
  ];

  environment.etc."xdg/wayland-sessions/mangowc.desktop".text = ''
    [Desktop Entry]
    Name=MangoWC
    Comment=Mango Wayland Compositor
    Exec=${session}
    Type=Application
    DesktopNames=MangoWC
  '';
}

{ pkgs, vars, ... }:

let
  session = pkgs.writeShellScript "mangowc-session" ''
    export XDG_CURRENT_DESKTOP=MangoWC
    ${vars.noctalia} &
    ${pkgs.dex}/bin/dex -a &
    exec ${pkgs.mangowc}/bin/mangowc "$@"
  '';
in
{
  environment.systemPackages = [ pkgs.mangowc pkgs.dex ];

  environment.etc."xdg/wayland-sessions/mangowc.desktop".text = ''
    [Desktop Entry]
    Name=MangoWC
    Comment=Mango Wayland Compositor
    Exec=${session}
    Type=Application
    DesktopNames=MangoWC
  '';
}

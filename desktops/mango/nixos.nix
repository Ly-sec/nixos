{ pkgs, vars, lib, noctaliaPackage, ... }:

let
  noctalia = lib.getExe noctaliaPackage;
  session = pkgs.writeShellScript "mangowc-session" ''
    export XDG_CURRENT_DESKTOP=MangoWC
    ${noctalia} &
    ${pkgs.dex}/bin/dex -a &
    exec ${pkgs.mango}/bin/mango "$@"
  '';
  sessionDesktop = pkgs.writeTextFile {
    name = "mangowc-desktop";
    destination = "/share/wayland-sessions/mangowc.desktop";
    text = ''
      [Desktop Entry]
      Name=MangoWC
      Comment=Mango Wayland Compositor
      Exec=${session}
      Type=Application
      DesktopNames=MangoWC
    '';
  };
in
{
  environment.systemPackages = [ pkgs.mango pkgs.dex sessionDesktop ];
}

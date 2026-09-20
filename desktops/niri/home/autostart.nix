{
  pkgs,
  lib,
  ...
}:

let
  noctalia = lib.getExe pkgs.noctalia;
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ noctalia ]; }
    { sh = "sleep 4; ${pkgs.fluxer-canary}/bin/fluxer-canary"; }
    { sh = "sleep 4; ${pkgs.vesktop}/bin/vesktop"; }
  ];
}

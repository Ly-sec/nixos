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
    { command = [ noctalia ]; }
    { sh = "sleep 4; ${pkgs.vesktop}/bin/vesktop"; }
  ];
}

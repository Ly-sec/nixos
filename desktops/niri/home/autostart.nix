{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:

let
  fluxer = import ../../../lib/fluxer.nix { inherit pkgs inputs; };
  noctalia = lib.getExe config.lysec.noctaliaPackage;
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ noctalia ]; }
    { sh = "sleep 4; ${fluxer}/bin/fluxer-canary"; }
    { sh = "sleep 4; ${pkgs.vesktop}/bin/vesktop"; }
  ];
}

{ pkgs, inputs, vars, ... }:

let
  fluxer = import ../../../lib/fluxer.nix { inherit pkgs inputs; };
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ vars.noctalia ]; }
    { sh = "sleep 4; ${fluxer}/bin/fluxer-canary"; }
    { sh = "sleep 4; ${pkgs.vesktop}/bin/vesktop"; }
  ];
}

{ config, pkgs, vars, ... }:

let
  noctalia = import ../../../lib/noctalia.nix { inherit pkgs vars; };
  fluxer = "${config.home.path}/bin/fluxer-canary";
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { command = [ "${noctalia.autostart}/bin/noctalia-autostart" ]; }
    { sh = "sleep 2; ${fluxer}"; }
    { sh = "sleep 4; ${pkgs.vesktop}/bin/vesktop"; }
  ];
}

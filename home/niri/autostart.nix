{ config, pkgs, inputs, ... }:

let
  noctalia = import ./noctalia-path.nix;
  fluxer = "${config.home.path}/bin/fluxer-canary";
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { sh = noctalia; }
    { sh = "sleep 2; ${fluxer}"; }
    { sh = "sleep 4; ${pkgs.vesktop}/bin/vesktop"; }
  ];
}

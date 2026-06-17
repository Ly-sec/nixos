{ ... }:

let
  noctalia = import ./noctalia-path.nix;
in
{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { sh = noctalia; }
    { sh = "sleep 1; fluxer-canary"; }
    { sh = "sleep 3; vesktop"; }
  ];
}

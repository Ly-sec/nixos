{ vars, ... }:

{
  programs.niri.settings.spawn-at-startup = [
    { command = [ "xwayland-satellite" ]; }
    { sh = vars.noctalia; }
    { sh = "sleep 1; fluxer-canary"; }
    { sh = "sleep 3; vesktop"; }
  ];
}

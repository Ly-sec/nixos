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
  programs.umbriel.settings.general.autostart = [
    noctalia
    "sleep 4; ${fluxer}/bin/fluxer-canary"
    "sleep 4; ${pkgs.vesktop}/bin/vesktop"
  ];
}

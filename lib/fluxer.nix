{ pkgs, inputs }:

let
  fluxerCanary = inputs.fluxer.packages.${pkgs.stdenv.hostPlatform.system}.fluxer-canary;
in
pkgs.writeShellApplication {
  name = "fluxer-canary";
  runtimeInputs = [ fluxerCanary ];
  text = ''
    export ELECTRON_OZONE_PLATFORM_HINT=x11
    exec ${fluxerCanary}/bin/fluxer-canary "$@"
  '';
}

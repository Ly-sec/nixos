{ pkgs, inputs, ... }:

let
  fluxerCanary = inputs.fluxer.packages.${pkgs.stdenv.hostPlatform.system}.fluxer-canary;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "fluxer-canary";
      runtimeInputs = [ fluxerCanary ];
      text = ''
        if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
          exec ${fluxerCanary}/bin/fluxer-canary --ozone-platform=x11 "$@"
        else
          exec ${fluxerCanary}/bin/fluxer-canary "$@"
        fi
      '';
    })
  ];
}

{ inputs }:

final: _prev:

let
  system = final.stdenv.hostPlatform.system;
in
{
  agenix = inputs.agenix.packages.${system}.default;
  helium-widevine = inputs.helium.packages.${system}.helium-widevine;
  noctalia = inputs.noctalia.packages.${system}.default;
  noctalia-greeter = inputs.noctalia-greeter.packages.${system}.default;
  swash = inputs.swash.packages.${system}.default;
  xwayland-satellite = inputs.xwayland-satellite.packages.${system}.default;
}

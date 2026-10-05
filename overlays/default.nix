{ inputs }:

final: _prev:

let
  system = final.stdenv.hostPlatform.system;
in
{
  agenix = inputs.agenix.packages.${system}.default;
  helium-widevine = inputs.helium.packages.${system}.helium-widevine;
  # Path inputs have no Git revision metadata; label this development build local.
  noctalia = final.callPackage (inputs.noctalia.outPath + "/nix/package.nix") {
    rev = "local";
  };
  noctalia-greeter = inputs.noctalia-greeter.packages.${system}.default;
  swash = inputs.swash.packages.${system}.default;
}

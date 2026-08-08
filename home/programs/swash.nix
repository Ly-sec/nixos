{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.swash.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.tesseract
  ];
}

{ pkgs, ... }:

{
  home.packages = [
    pkgs.swash
    pkgs.tesseract
  ];
}

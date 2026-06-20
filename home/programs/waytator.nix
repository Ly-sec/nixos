{ pkgs, lib, inputs, ... }:

let
  waytator = inputs.waytator.packages.${pkgs.stdenv.hostPlatform.system}.default;
  scriptBody = builtins.readFile "${inputs.waytator}/scripts/screenshot-to-waytator.sh";
in
{
  home.packages = [
    waytator
    pkgs.tesseract
    (pkgs.writeShellScriptBin "screenshot-to-waytator.sh" ''
      export PATH="${lib.makeBinPath [
        waytator
        pkgs.wl-clipboard
        pkgs.jq
        pkgs.niri
        pkgs.coreutils
      ]}:$PATH"
      ${scriptBody}
    '')
  ];
}

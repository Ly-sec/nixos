{ config, pkgs, lib, ... }:

let
  niriPkg = config.programs.niri.package;
  base = config.programs.niri.finalConfig;
  withNoctalia = base + ''

    include optional=true "noctalia.kdl"
  '';
in
{
  # Noctalia writes theme snippets here; niri only loads them via top-level include.
  xdg.configFile.niri-config.source = lib.mkForce (
    pkgs.runCommand "config.kdl" {
    config = withNoctalia;
    passAsFile = [ "config" ];
    buildInputs = [ niriPkg ];
  } ''
    niri validate -c $configPath
    cp $configPath $out
  ''
  );
}

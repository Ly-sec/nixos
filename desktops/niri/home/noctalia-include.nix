{ config, pkgs, lib, ... }:

let
  niriPkg = config.programs.niri.package;
  withNoctalia = config.programs.niri.finalConfig + ''

    include optional=true "noctalia.kdl"
  '';
in
{
  xdg.configFile.niri-config = lib.mkForce {
    target = "niri/config.kdl";
    force = true;
    source = pkgs.runCommand "config.kdl" {
      config = withNoctalia;
      passAsFile = [ "config" ];
      buildInputs = [ niriPkg ];
    } ''
      niri validate -c $configPath
      cp $configPath $out
    '';
  };
}

{
  lib,
  inputs,
  pkgs,
  ...
}:

{
  options.lysec.noctaliaPackage = lib.mkOption {
    type = lib.types.package;
    description = "Noctalia package from the noctalia flake input";
  };

  config.lysec.noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
}

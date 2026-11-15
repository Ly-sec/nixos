{
  config,
  lib,
  ...
}: let
  system = config.lysec.system;
  host = config.flake.nixosConfigurations.nixos.config;
  pkgs = config.flake.nixosConfigurations.nixos.pkgs;
  home = host.home-manager.users.${config.lysec.username};
  files =
    lib.filterAttrs (
      name: value:
        value.enable
        && lib.hasPrefix "noctalia/" name
        && lib.hasSuffix ".toml" name
    )
    home.xdg.configFile;
  fixture = pkgs.linkFarm "noctalia-public-config" (lib.mapAttrsToList (name: value: {
      name = lib.removePrefix "noctalia/" name;
      path = value.source;
    })
    files);
in {
  flake.checks.${system} = {
    noctalia-config =
      pkgs.runCommand "noctalia-config-validated" {
        nativeBuildInputs = [pkgs.noctalia pkgs.gnugrep];
      } ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"
        noctalia config validate ${fixture} > diagnostics 2>&1 || {
          cat diagnostics
          exit 1
        }
        cat diagnostics
        if grep -E 'unknown setting|unknown section' diagnostics; then
          exit 1
        fi
        touch "$out"
      '';
  };
}

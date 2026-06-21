{ pkgs, vars, lib, inputs, ... }:

let
  desktops = import ../../lib/desktops.nix;
  desktop = desktops.assertValid vars.desktop;
  useGreeter = desktops.usesGreetd desktop;

  noctaliaGreeter =
    inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        src = lib.cleanSourceWith {
          src = old.src;
          filter =
            path: type:
            let base = baseNameOf path;
            in base != "build" && base != "build-release" && base != "build-asan";
        };
      });
in
{
  imports = lib.optionals useGreeter [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.noctalia-greeter = lib.mkIf useGreeter {
    enable = true;
    package = noctaliaGreeter;
    greeter-args = "--session ${desktops.greeterSession desktop}";
    settings.cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };
}

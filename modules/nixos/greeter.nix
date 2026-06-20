{ pkgs, vars, lib, inputs, ... }:

let
  desktops = import ../../lib/desktops.nix;
  desktop = desktops.assertValid vars.desktop;
  useGreeter = desktops.usesGreetd desktop;

  greeterSrc = pkgs.lib.cleanSourceWith {
    src = inputs.noctalia-greeter;
    filter =
      path: type:
      let
        base = baseNameOf path;
      in
      base != "build" && base != "build-release" && base != "build-asan";
  };

  noctaliaGreeter = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    src = greeterSrc;
  });
in
{
  imports = lib.optionals useGreeter [
    inputs.noctalia-greeter.nixosModules.default
  ];

  users.groups.greeter = lib.mkIf useGreeter { };

  users.users.greeter = lib.mkIf useGreeter {
    isSystemUser = true;
    group = "greeter";
    description = "Noctalia greeter (greetd)";
  };

  programs.noctalia-greeter = lib.mkIf useGreeter {
    enable = true;
    package = noctaliaGreeter;
    greeter-args = "--session ${desktops.greeterSession desktop} --user ${vars.username}";
    settings.cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  systemd.services.greetd.serviceConfig = lib.mkIf useGreeter {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  system.activationScripts.noctaliaGreeter = lib.mkIf useGreeter ''
    mkdir -p /var/lib/noctalia-greeter
    touch /var/log/noctalia-greeter.log /var/lib/noctalia-greeter/greeter.log
    chown greeter:greeter /var/lib/noctalia-greeter \
      /var/log/noctalia-greeter.log /var/lib/noctalia-greeter/greeter.log 2>/dev/null || true
    chmod 0750 /var/lib/noctalia-greeter
    chmod 0664 /var/log/noctalia-greeter.log /var/lib/noctalia-greeter/greeter.log 2>/dev/null || true
    GREETD_CONFIG=/etc/greetd/config.toml \
      ${noctaliaGreeter}/bin/noctalia-greeter-apply-appearance --setup-system
  '';
}

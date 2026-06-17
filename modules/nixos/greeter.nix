{ pkgs, vars, lib, ... }:

let
  desktops = import ../../lib/desktops.nix;
  desktop = desktops.assertValid vars.desktop;
in
{
  services.greetd = lib.mkIf (desktops.usesGreetd desktop) {
    enable = true;
    settings.default_session = {
      command = desktops.greetdSession desktop pkgs;
      user = "greeter";
    };
  };

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
  systemd.services.greetd.serviceConfig = lib.mkIf (desktops.usesGreetd desktop) {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}

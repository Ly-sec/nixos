{ pkgs, vars, ... }:

let
  noctalia = import ../../../lib/noctalia.nix { inherit pkgs vars; };
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "${noctalia.autostart}/bin/noctalia-autostart"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Ice"
      ];

      input = {
        kb_layout = "de";
        numlock_by_default = true;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, ${ghostty}"
        "$mod, B, exec, ${firefox}"
        "$mod, Ctrl, Return, exec, ${noctalia.toggleLauncher}/bin/noctalia-toggle-launcher"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
      ];
    };
  };
}

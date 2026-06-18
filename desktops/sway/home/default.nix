{ pkgs, vars, ... }:

let
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
in
{
  wayland.windowManager.sway = {
    enable = true;
    xwayland.enable = true;
    config = {
      modifier = "Mod4";
      terminal = ghostty;
      menu = firefox;

      input = {
        xkb_layout = "de";
        xkb_numlock = "enabled";
        xkb_variant = "";
        natural_scroll = "enabled";
      };

      gaps = {
        inner = 5;
        outer = 10;
      };

      keybindings = {
        "Mod4+Return" = "exec ${ghostty}";
        "Mod4+b" = "exec ${firefox}";
        "Mod4+Control+Return" = "exec ${vars.noctalia} msg panel-toggle launcher";
        "Mod4+Shift+q" = "kill";
        "Mod4+Shift+e" = "exit";
      };
    };

    extraConfig = ''
      exec ${vars.noctalia}
    '';
  };
}

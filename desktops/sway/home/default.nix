{
  pkgs,
  lib,
  config,
  ...
}:

let
  kitty = "${pkgs.kitty}/bin/kitty";
  browser = config.home.sessionVariables.BROWSER;
  noctalia = lib.getExe config.lysec.noctaliaPackage;
in
{
  wayland.windowManager.sway = {
    enable = true;
    xwayland.enable = true;
    config = {
      modifier = "Mod4";
      terminal = kitty;
      menu = browser;

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
        "Mod4+Return" = "exec ${kitty}";
        "Mod4+b" = "exec ${browser}";
        "Mod4+Control+Return" = "exec ${noctalia} msg panel-toggle launcher";
        "Mod4+Shift+q" = "kill";
        "Mod4+Shift+e" = "exit";
      };
    };

    extraConfig = ''
      exec ${noctalia}
    '';
  };
}

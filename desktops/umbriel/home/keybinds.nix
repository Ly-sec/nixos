{
  config,
  pkgs,
  lib,
  ...
}:

let
  browser = config.home.sessionVariables.BROWSER;
  nautilus = "${pkgs.nautilus}/bin/nautilus";
  noctalia = lib.getExe pkgs.noctalia;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in
{
  programs.umbriel.settings.keybinds = {
    "Mod+Return" = "spawn:${pkgs.kitty}/bin/kitty";
    "Mod+Ctrl+Return" = "spawn:${noctalia} msg panel-toggle launcher";
    "Alt+Tab" = "spawn:${noctalia} msg window-switcher";
    "Mod+B" = "spawn:${browser}";
    "Mod+E" = "spawn:${nautilus}";

    "XF86AudioMute" = "spawn:${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "Mod+Delete" = "spawn:${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    "Mod+Page_Up" = "spawn:${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
    "Mod+Page_Down" = "spawn:${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05-";

    "Mod+O" = "overview-toggle";

    "Mod+WheelUp" = {
      action = "workspace-previous";
      cooldown_ms = 150;
    };
    "Mod+WheelDown" = {
      action = "workspace-next";
      cooldown_ms = 150;
    };
    "Mod+Shift+Ctrl+Left" = "window-move-to-output-left";
    "Mod+Shift+Ctrl+Right" = "window-move-to-output-right";
    "Mod+Shift+Ctrl+Up" = "window-move-to-workspace-previous";
    "Mod+Shift+Ctrl+Down" = "window-move-to-workspace-next";

    "Mod+Q" = "window-close";
    "Ctrl+Alt+Delete" = "session-quit";
    "Mod+Escape" = "session-quit";

    "Mod+Left" = "window-focus-left";
    "Mod+H" = "window-focus-left";
    "Mod+Right" = "window-focus-right";
    "Mod+L" = "window-focus-right";
    "Mod+Up" = "window-focus-up";
    "Mod+K" = "window-focus-up";
    "Mod+Down" = "window-focus-down";
    "Mod+J" = "window-focus-down";

    "Mod+Shift+Left" = "window-modify-primary-extent:-0.1";
    "Mod+Shift+Right" = "window-modify-primary-extent:0.1";

    # Named submap for testing `umbriel submap`.
    "Mod+S" = {
      action = "submap:test";
      repeat = false;
    };
    "submap[test],Escape" = "submap:reset";

    # Scratchpads
    "Mod+Space" = "scratchpad-toggle:terminal";
    "Mod+Shift+Space" = "window-move-to-scratchpad:terminal";
    "Mod+Ctrl+Space" = "window-restore-from-scratchpad:terminal";
    "Mod+Tab" = "scratchpad-focus-next:terminal";

    "Mod+Alt+Space" = "scratchpad-toggle:music";
    "Mod+Alt+Shift+Space" = "window-move-to-scratchpad:music";
    "Mod+Alt+Ctrl+Space" = "window-restore-from-scratchpad:music";
    "Mod+Alt+Tab" = "scratchpad-focus-next:music";

    "Mod+Ctrl+Left" = "column-move-left";
    "Mod+Ctrl+H" = "column-move-left";
    "Mod+Ctrl+Right" = "column-move-right";
    "Mod+Ctrl+L" = "column-move-right";
    "Mod+Ctrl+Up" = "window-move-up";
    "Mod+Ctrl+K" = "window-move-up";
    "Mod+Ctrl+Down" = "window-move-down";
    "Mod+Ctrl+J" = "window-move-down";

    "Mod+comma" = "window-consume-left";
    "Mod+period" = "window-consume-or-expel-right";
    "Mod+R" = "window-cycle-primary-extent";
    "Mod+F" = "window-toggle-fullscreen";
    "Mod+Ctrl+F" = "window-toggle-maximize";
    "Mod+M" = "window-toggle-maximize-to-edges";
    "Mod+T" = "window-toggle-floating";
    "Mod+P" = "window-toggle-pinned";
    "Mod+F1" = "window-focus-next";
    "Mod+Shift+C" = "config-reload";

    "Mod+1" = "workspace-switch:1";
    "Mod+2" = "workspace-switch:2";
    "Mod+3" = "workspace-switch:3";
    "Mod+4" = "workspace-switch:4";
    "Mod+5" = "workspace-switch:5";
    "Mod+6" = "workspace-switch:6";
    "Mod+7" = "workspace-switch:7";
    "Mod+8" = "workspace-switch:8";
    "Mod+9" = "workspace-switch:9";

    "Mod+Ctrl+1" = "window-move-to-workspace:1";
    "Mod+Ctrl+2" = "window-move-to-workspace:2";
    "Mod+Ctrl+3" = "window-move-to-workspace:3";
    "Mod+Ctrl+4" = "window-move-to-workspace:4";
    "Mod+Ctrl+5" = "window-move-to-workspace:5";
    "Mod+Ctrl+6" = "window-move-to-workspace:6";
    "Mod+Ctrl+7" = "window-move-to-workspace:7";
    "Mod+Ctrl+8" = "window-move-to-workspace:8";
    "Mod+Ctrl+9" = "window-move-to-workspace:9";

    "Ctrl+Alt+1" = "spawn:${noctalia} msg screenshot-region";
  };
}

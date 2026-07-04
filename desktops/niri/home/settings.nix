{ ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;
    screenshot-path = null;

    outputs = {
      "DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 359.979;
        };
        scale = 1.0;
      };
      "DP-2" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 164.917;
        };
        #transform.rotation = 90;
        scale = 1.0;
      };
    };

    workspaces = {
      browser = { };
      chat = { };
      vesktop = { open-on-output = "DP-2"; };
      fluxer = { open-on-output = "DP-2"; };
    };

    hotkey-overlay.skip-at-startup = true;

    layout = {
      gaps = 14;
      center-focused-column = "never";
      background-color = "transparent";

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width = { proportion = 0.4; };

      struts = { };

      focus-ring.enable = true;
    };

    input = {
      keyboard = {
        xkb.layout = "de";
        numlock = true;
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
      focus-follows-mouse.enable = true;
      workspace-auto-back-and-forth = true;
    };

    cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
    };

    environment = {
      ELECTRON_OZONE_PLATFORM_HINT = "x11";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = "Bibata-Modern-Ice";
      QT_QPA_PLATFORMTHEME = "gtk3";
      EDITOR = "code";
    };
  };
}

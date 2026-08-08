{ pkgs, ... }:

{
  programs.umbriel.settings = {
    general = {
    };

    appearance = {
      prefer_no_csd = true;
      border_width = 2;
      outer_border_width = 13;
      corner_radius = 0;
      animation_ms = 250;
      shadow = {
        enabled = false;
      };
      blur = {
        enabled = false;
        passes = 1;
        radius = 5;
        noise = 0.0;
        brightness = 0.9;
        contrast = 0.9;
        saturation = 1.1;
	optimized = true;
      };
    };

    layout = {
      mode = "scrolling";
      gap = 5;
      default_width_fraction = 0.4;
      width_presets = [
        0.333
        0.5
        0.667
      ];
    };

    "output"."DP-1" = {
      mode = "2560x1440@359.979";
      position = [
        0
        0
      ];
      scale = 1.0;
      transform = "normal";
    };

    "output"."DP-2" = {
      mode = "1920x1080@164.917";
      position = [
        2560
        0
      ];
      scale = 1.0;
      transform = "normal";
    };

    input = {
      keyboard = {
        layout = "de";
        variant = "";
        repeat_rate = 25;
        repeat_delay = 600;
      };
      touchpad = {
        tap = true;
        natural_scroll = true;
      };
      mouse = {
        scroll_wheel_step = 60;
      };
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
      };
      focus = {
        follows_mouse = true;
      };
    };

    workspaces = {
      back_and_forth = true;
    };

    rule = [
      {
        match.app_id = "^firefox$";
	default_maximize = true;
      }
      {
	match.app_id = "^dev.lemmy.swash$";
	default_floating = true; 
      }
      {
        match.app_id = "^vesktop$";
        default_workspace = 1;
	default_maximize = true;
        default_output = "DP-2";
      }
      {
        match.app_id = "^fluxer-canary$";
        default_workspace = 2;
	default_maximize = true;
        default_output = "DP-2";
      }
    ];
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Umbriel";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Umbriel";
  };
}

{ ... }:

{
  programs.umbriel.settings = {
    general.show_cheatsheet = false;

    scratchpad = [
      { name = "terminal"; }
      { name = "music"; }
    ];

    environment = {
      PROTON_ENABLE_WAYLAND = "1";
      DXVK_HDR = "1";
    };

    colors.shadow = "#00FFFFAA";

    appearance = {
      prefer_no_csd = true;
      border_width = 2;
      outer_border_width = 13;
      corner_radius = 0;

      shadow = {
        enabled = false;
        softness = 0;
        offset_x = 5;
        offset_y = 5;
      };

      blur = {
        enabled = true;
        passes = 3;
        radius = 5;
        noise = 0.0;
        brightness = 0.9;
        contrast = 0.9;
        saturation = 1.1;
        optimized = false;
      };
    };

    hot_corners.bottom_left = {
      enabled = true;
      delay_ms = 500;
      action = "overview-toggle";
    };
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Umbriel";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Umbriel";
  };
}

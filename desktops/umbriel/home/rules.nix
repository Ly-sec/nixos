{ ... }:

{
  programs.umbriel.settings = {
    layer_rule = [
      {
        match.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^"]*)$'';
        blur = true;
        blur_ignore_alpha = 0.5;
        blur_popups = true;
      }
    ];

    window_rule = [
      {
        match.is_focused = true;
        blur = true;
        blur_popups = true;
        opacity = 1.0;
      }
      {
        match.is_focused = false;
        blur = true;
        blur_popups = true;
        opacity = 1.0;
      }
      # {
      #   match.app_id = "^(steam_app_[0-9]+|gamescope)$";
      #   hdr = "on";
      # }
      # {
      #   match.app_id = "^Minecraft[*]$";
      #   hdr = "fullscreen";
      # }
      {
        match.app_id = "^firefox$";
        default_maximize = true;
      }
      {
        match.app_id = "^dev.lemmy.swash$";
        default_floating = true;
      }
      {
        match.app_id = "^dev\\.noctalia\\.UmbrielSharePicker$";
        default_floating = true;
        default_size = [
          800
          600
        ];
      }
      {
        match.app_id = "^vesktop$";
        default_workspace = 1;
        default_focused = false;
        default_maximize = true;
        default_output = "DP-2";
      }
      {
        match.app_id = "^fluxer-canary$";
        default_workspace = 2;
        default_focused = false;
        default_maximize = true;
        default_output = "DP-2";
      }
      {
        match.title = "^notificationtoasts_.+_desktop";
        default_position = {
          x = 12;
          y = 12;
          anchor = "bottom_right";
        };
        default_output = "DP-1";
        default_focused = false;
      }
    ];
  };
}

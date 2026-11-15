{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/42-lockscreen-widgets.toml".source = (pkgs.formats.toml {}).generate "42-lockscreen-widgets.toml" {
      "lockscreen_widgets" = {
        "enabled" = true;
        "schema_version" = 2;
        "widget_order" = [
          "lockscreen-login-box@HEADLESS-1"
          "lockscreen-login-box@WL-1"
          "lockscreen-widget-0000000000000002"
          "lockscreen-login-box@DP-1"
          "lockscreen-login-box@DP-2"
          "lockscreen-widget-0000000000000001"
        ];
        "grid" = {
          "cell_size" = 16;
          "major_interval" = 4;
          "visible" = true;
        };
        "widget" = {
          "lockscreen-login-box@DP-1" = {
            "box_height" = 196.0;
            "box_width" = 810.0;
            "cx" = 1280.0;
            "cy" = 1325.9141845703125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "login_box";
            "settings" = {
              "background_color" = "surface_container";
              "background_opacity" = 1.0;
              "background_radius" = 12.0;
              "center_password_text" = true;
              "input_opacity" = 1.0;
              "input_radius" = 6.0;
              "layout" = "regular";
              "show_caps_lock" = true;
              "show_keyboard_layout" = true;
              "show_login_button" = true;
              "show_media" = true;
              "show_session_buttons" = true;
              "show_unlock_hint" = false;
              "show_weather" = true;
            };
          };
          "lockscreen-login-box@DP-2" = {
            "box_height" = 70.0;
            "box_width" = 336.0;
            "cx" = 960.0;
            "cy" = 1000.5;
            "output" = "DP-2";
            "placement_height" = 1080.0;
            "placement_width" = 1920.0;
            "rotation" = 0.0;
            "type" = "login_box";
            "settings" = {
              "background_color" = "surface_container";
              "background_opacity" = 0.88;
              "background_radius" = 12.0;
              "center_password_text" = false;
              "input_opacity" = 1.0;
              "input_radius" = 6.0;
              "layout" = "compact";
              "show_caps_lock" = false;
              "show_keyboard_layout" = true;
              "show_login_button" = true;
              "show_media" = true;
              "show_session_buttons" = true;
              "show_unlock_hint" = true;
              "show_weather" = true;
            };
          };
          "lockscreen-login-box@HEADLESS-1" = {
            "box_height" = 196.0;
            "box_width" = 810.0;
            "cx" = 640.0;
            "cy" = 538.0;
            "output" = "HEADLESS-1";
            "placement_height" = 720.0;
            "placement_width" = 1280.0;
            "rotation" = 0.0;
            "type" = "login_box";
            "settings" = {
              "background_color" = "surface_container";
              "background_opacity" = 0.88;
              "background_radius" = 12.0;
              "center_password_text" = false;
              "input_opacity" = 1.0;
              "input_radius" = 6.0;
              "layout" = "regular";
              "show_caps_lock" = true;
              "show_keyboard_layout" = true;
              "show_login_button" = true;
              "show_media" = true;
              "show_session_buttons" = true;
              "show_unlock_hint" = true;
              "show_weather" = true;
            };
          };
          "lockscreen-login-box@WL-1" = {
            "box_height" = 196.0;
            "box_width" = 810.0;
            "cx" = 1272.0;
            "cy" = 1215.0;
            "output" = "WL-1";
            "placement_height" = 0.0;
            "placement_width" = 0.0;
            "rotation" = 0.0;
            "type" = "login_box";
            "settings" = {
              "background_color" = "surface_container";
              "background_opacity" = 0.88;
              "background_radius" = 12.0;
              "center_password_text" = false;
              "input_opacity" = 1.0;
              "input_radius" = 6.0;
              "layout" = "regular";
              "show_caps_lock" = true;
              "show_keyboard_layout" = true;
              "show_login_button" = true;
              "show_media" = true;
              "show_session_buttons" = true;
              "show_unlock_hint" = true;
              "show_weather" = true;
            };
          };
          "lockscreen-widget-0000000000000001" = {
            "box_height" = 0.0;
            "box_width" = 0.0;
            "cx" = 2480.0;
            "cy" = 48.0;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "clock";
            "settings" = {
              "background" = false;
              "clock_style" = "digital";
            };
          };
          "lockscreen-widget-0000000000000002" = {
            "box_height" = 96.0;
            "box_width" = 672.0;
            "cx" = 1264.60546875;
            "cy" = 1231.7421875;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "audio_visualizer";
            "settings" = {
              "background" = false;
              "bands" = 32;
              "show_when_idle" = true;
            };
          };
        };
      };
    };
  };
}

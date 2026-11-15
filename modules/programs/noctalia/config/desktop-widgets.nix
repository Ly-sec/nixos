{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/40-desktop-widgets.toml".source = (pkgs.formats.toml {}).generate "40-desktop-widgets.toml" {
      "desktop_widgets" = {
        "schema_version" = 2;
        "widget_order" = [
          "desktop-widget-0000000000000015"
          "desktop-widget-0000000000000014"
          "desktop-widget-0000000000000013"
          "desktop-widget-0000000000000012"
          "desktop-widget-0000000000000010"
          "desktop-widget-0000000000000001"
          "desktop-widget-0000000000000004"
          "desktop-widget-000000000000000e"
          "desktop-widget-000000000000000f"
          "desktop-widget-0000000000000011"
          "desktop-widget-0000000000000016"
          "desktop-widget-0000000000000017"
          "desktop-widget-0000000000000009"
          "desktop-widget-000000000000000a"
          "desktop-widget-000000000000000c"
          "desktop-widget-0000000000000018"
        ];
        "grid" = {
          "cell_size" = 16;
          "major_interval" = 4;
          "visible" = true;
        };
        "widget" = {
          "desktop-widget-0000000000000001" = {
            "box_height" = 128.0;
            "box_width" = 720.0;
            "cx" = 1280.0;
            "cy" = 79.99996948242188;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = -3.1415927410125732;
            "type" = "audio_visualizer";
            "settings" = {
              "background" = false;
              "bands" = 60;
              "centered" = false;
              "show_when_idle" = false;
            };
          };
          "desktop-widget-0000000000000004" = {
            "box_height" = 128.0;
            "box_width" = 720.0;
            "cx" = 1280.0;
            "cy" = 1378.19921875;
            "enabled" = false;
            "flip_y" = true;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = -3.1415927410125732;
            "type" = "audio_visualizer";
            "settings" = {
              "background" = false;
              "bands" = 60;
              "centered" = false;
              "show_when_idle" = false;
            };
          };
          "desktop-widget-0000000000000009" = {
            "box_height" = 76.06231689453125;
            "box_width" = 130.9400634765625;
            "cx" = 1157.6015625;
            "cy" = 1232.5311279296875;
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
          "desktop-widget-000000000000000a" = {
            "box_height" = 44.796875;
            "box_width" = 90.00390625;
            "cx" = 1234.00390625;
            "cy" = 1232.80078125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "clock";
            "settings" = {
              "background" = false;
              "format" = "{:%d\\n%m}";
            };
          };
          "desktop-widget-000000000000000c" = {
            "box_height" = 80.0;
            "box_width" = 160.0;
            "cx" = 1389.59765625;
            "cy" = 1234.80078125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "weather";
            "settings" = {
              "background" = false;
              "background_opacity" = 1.0;
              "forecast_days" = 3;
              "shadow" = false;
              "show_forecast" = false;
            };
          };
          "desktop-widget-000000000000000e" = {
            "box_height" = 110.2890625;
            "box_width" = 421.3984375;
            "cx" = 1279.5;
            "cy" = 1347.14453125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "noctalia/lyrics:desktop";
            "settings" = {
              "background_opacity" = 1.0;
            };
          };
          "desktop-widget-000000000000000f" = {
            "box_height" = 201.29296875;
            "box_width" = 111.7998046875;
            "cx" = 1565.09912109375;
            "cy" = 1294.845703125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "media_player";
            "settings" = {
              "album_art_background" = true;
              "album_art_blur" = 8;
              "audio_visualizer" = true;
              "background" = true;
              "background_opacity" = 0.0;
            };
          };
          "desktop-widget-0000000000000010" = {
            "box_height" = 217.0;
            "box_width" = 125.599609375;
            "cx" = 1565.19921875;
            "cy" = 1295.39453125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "label";
            "settings" = {
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000011" = {
            "box_height" = 111.89940643310547;
            "box_width" = 203.0;
            "cx" = 993.94970703125;
            "cy" = 1296.0;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 1.5707963705062866;
            "type" = "audio_visualizer";
            "settings" = {
              "background" = false;
              "background_opacity" = 1.0;
              "bands" = 68;
              "reversed" = false;
              "show_wave" = false;
              "show_when_idle" = true;
            };
          };
          "desktop-widget-0000000000000012" = {
            "box_height" = 217.60546875;
            "box_width" = 124.201171875;
            "cx" = 993.8994140625;
            "cy" = 1296.298828125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "label";
            "settings" = {
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000013" = {
            "box_height" = 240.0;
            "box_width" = 720.0;
            "cx" = 1280.0;
            "cy" = 1296.0;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = -0.0;
            "type" = "label";
            "settings" = {
              "background_color" = "primary";
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000014" = {
            "box_height" = 256.0;
            "box_width" = 736.0;
            "cx" = 1280.0;
            "cy" = 1295.697265625;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "label";
            "settings" = {
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000015" = {
            "box_height" = 94.40625;
            "box_width" = 200.19921875;
            "cx" = 1388.5;
            "cy" = 1235.3280029296875;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "label";
            "settings" = {
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000016" = {
            "box_height" = 95.9500732421875;
            "box_width" = 200.203125;
            "cx" = 1389.900390625;
            "cy" = 1234.55615234375;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "label";
            "settings" = {
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000017" = {
            "box_height" = 95.0477294921875;
            "box_width" = 205.796875;
            "cx" = 1171.69921875;
            "cy" = 1234.41845703125;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "label";
            "settings" = {
              "background_opacity" = 1.0;
              "opacity" = 1.0;
              "title" = "";
            };
          };
          "desktop-widget-0000000000000018" = {
            "box_height" = 110.6015625;
            "box_width" = 422.80078125;
            "cx" = 1279.599609375;
            "cy" = 1347.5;
            "output" = "DP-1";
            "placement_height" = 1440.0;
            "placement_width" = 2560.0;
            "rotation" = 0.0;
            "type" = "noctalia/lyrics:desktop";
            "settings" = {
              "background_opacity" = 1.0;
            };
          };
        };
      };
    };
  };
}

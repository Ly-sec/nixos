{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/30-bars.toml".source = (pkgs.formats.toml {}).generate "30-bars.toml" {
      "bar" = {
        "order" = [
          "minimal"
          "minimal-DP2"
          "fancy"
        ];
        "fancy" = {
          "center" = [
            "notifications"
            "clock"
            "media"
          ];
          "end" = [
            "tray"
            "volume"
            "input_volume"
            "recorder_3"
            "session"
          ];
          "font_family" = "Noto Sans";
          "hover_highlight" = false;
          "margin_ends" = 0;
          "radius_top_left" = 0;
          "radius_top_right" = 0;
          "start" = [
            "workspaces"
          ];
          "widget_spacing" = 8;
        };
        "minimal" = {
          "capsule_radius" = 0;
          "center" = [
            "workspace_minimal"
          ];
          "color" = "on_surface_variant";
          "enabled" = false;
          "end" = [
            "left_bracket"
            "tray_minimal"
            "separator"
            "nix_monitor_2"
            "separator"
            "recorder_2"
            "separator"
            "volume_minimal"
            "separator"
            "volume_input_minimal"
            "separator"
            "brightness_minimal"
            "separator"
            "weather"
            "separator"
            "clock_minimal"
            "separator"
            "right_bracket"
            "session"
          ];
          "font_family" = "JetBrains Mono";
          "hover_highlight" = false;
          "margin_ends" = 0;
          "padding" = 5;
          "radius" = 0;
          "shadow" = false;
          "show_on_workspace_switch" = false;
          "start" = [
            "left_bracket"
            "cpu_usage_minimal"
            "separator"
            "cpu_temp_minimal"
            "separator"
            "ram_usage_minimal"
            "right_bracket"
          ];
          "thickness" = 27;
          "monitor" = {
            "DP-2" = {
              "enabled" = false;
            };
          };
        };
        "minimal-DP2" = {
          "center" = [
            "cpu_usage_minimal"
            "separator"
            "cpu_temp_minimal"
            "separator"
            "ram_usage_minimal"
          ];
          "color" = "on_surface_variant";
          "enabled" = false;
          "end" = [];
          "font_family" = "JetBrains Mono";
          "font_scale" = 0.8499999884516001;
          "hover_highlight" = false;
          "margin_ends" = 0;
          "padding" = 5;
          "radius" = 0;
          "start" = [
            "clock_minimal"
          ];
          "thickness" = 21;
          "monitor" = {
            "DP-1" = {
              "enabled" = false;
            };
          };
        };
      };
    };
  };
}

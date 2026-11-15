{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/37-widgets-plugins.toml".source = (pkgs.formats.toml {}).generate "37-widgets-plugins.toml" {
      "widget" = {
        "cat" = {
          "type" = "noctalia/bongocat:cat";
        };
        "cat_2" = {
          "type" = "noctalia/bongocat:cat";
        };
        "cat_3" = {
          "type" = "noctalia/bongocat:cat";
        };
        "cat_4" = {
          "type" = "noctalia/bongocat:cat";
        };
        "nix-monitor" = {
          "colorize_glyph" = false;
          "show_text" = false;
          "type" = "avivbintangaringga/nix-monitor:nix-monitor";
        };
        "nix_monitor_2" = {
          "checking_color" = "on_surface";
          "show_text" = false;
          "type" = "avivbintangaringga/nix-monitor:nix-monitor";
          "up_to_date_color" = "on_surface";
          "update_available_color" = "on_surface";
        };
        "notes" = {
          "type" = "noctalia/notes:notes";
        };
        "recorder" = {
          "type" = "noctalia/screen_recorder:recorder";
        };
        "recorder_2" = {
          "type" = "noctalia/screen_recorder:recorder";
        };
        "recorder_3" = {
          "type" = "noctalia/screen_recorder:recorder";
        };
      };
    };
  };
}

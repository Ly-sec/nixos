{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/36-widgets-media.toml".source = (pkgs.formats.toml {}).generate "36-widgets-media.toml" {
      "widget" = {
        "input_volume" = {
          "glyph_position" = "after";
          "peek" = true;
          "peek_delay_ms" = 350;
        };
        "media" = {
          "glyph_position" = "after";
          "peek" = true;
          "peek_delay_ms" = 350;
          "show_glyph" = false;
        };
        "volume" = {
          "glyph_position" = "after";
          "peek" = true;
          "peek_delay_ms" = 350;
        };
        "volume_input_minimal" = {
          "device" = "input";
          "type" = "volume";
        };
        "volume_minimal" = {
          "font_family" = "JetBrains Mono";
          "type" = "volume";
        };
      };
    };
  };
}

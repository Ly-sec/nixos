{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/60-theme.toml".source = (pkgs.formats.toml {}).generate "60-theme.toml" {
      "theme" = {
        "builtin" = "Gruvbox";
        "community_palette" = "Everforest";
        "custom_palette" = "verdant-nocturne";
        "mode" = "dark";
        "source" = "custom";
        "wallpaper_scheme" = "vibrant";
        "templates" = {
          "builtin_ids" = [
            "btop"
            "emacs"
            "gtk3"
            "gtk4"
            "kitty"
            "qt"
            "umbriel"
          ];
          "community_ids" = [
            "sonora"
            "chromium-based"
            "pywalfox-beta4"
            "cressida"
            "discord"
          ];
        };
      };
    };
  };
}

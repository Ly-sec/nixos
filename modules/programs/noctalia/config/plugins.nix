{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/50-plugins.toml".source = (pkgs.formats.toml {}).generate "50-plugins.toml" {
      "plugins" = {
        "auto_update" = "all";
        "enabled" = [
          "noctalia/kaomoji"
          "noctalia/notes"
          "noctalia/bongocat"
          "avivbintangaringga/nix-monitor"
          "noctalia/timer"
          "radimous/prismlauncher-instances"
          "noctalia/bitwarden"
          "noctalia/screen_recorder"
          "noctalia/world_clock"
          "noctalia/translator"
          "noctalia/umbriel-companion"
          "shangshui0302/github-kanban"
          "noctalia/lyrics"
        ];
        "source" = [
          {
            "kind" = "git";
            "location" = "https://github.com/noctalia-dev/official-plugins";
            "name" = "official";
          }
          {
            "kind" = "git";
            "location" = "https://github.com/noctalia-dev/community-plugins";
            "name" = "community";
          }
          {
            "enabled" = false;
            "kind" = "path";
            "location" = "/mnt/storage/GitHub/noctalia-dev/official-plugins";
            "name" = "yes";
          }
        ];
      };
      "plugin_settings" = {
        "avivbintangaringga/nix-monitor" = {
          "clean_command" = "nh clean all";
          "update_command" = "nix flake update --flake ~/nixos";
        };
        "noctalia/bitwarden" = {
          "gen_special" = true;
        };
        "shangshui0302/github-kanban" = {
          "bar_display_mode" = "icon";
          "kanban_placement" = "floating";
        };
      };
    };
  };
}

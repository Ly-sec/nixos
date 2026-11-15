{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/33-notifications.toml".source = (pkgs.formats.toml {}).generate "33-notifications.toml" {
      "notification" = {
        "background_opacity" = 0.9999999776482582;
        "filter_order" = [];
        "history_retention_hours" = 1;
      };
    };
  };
}

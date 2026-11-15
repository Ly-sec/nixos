{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/20-system.toml".source = (pkgs.formats.toml {}).generate "20-system.toml" {
      "system" = {
        "monitor" = {
          "cpu_temp_activity_threshold" = 70;
        };
      };
    };
  };
}

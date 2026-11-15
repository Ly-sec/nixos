{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/18-nightlight.toml".source = (pkgs.formats.toml {}).generate "18-nightlight.toml" {
      "nightlight" = {
        "temperature_night" = 3600;
      };
    };
  };
}

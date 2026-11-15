{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/12-appearance.toml".source = (pkgs.formats.toml {}).generate "12-appearance.toml" {
      "backdrop" = {
        "blur_intensity" = 0.29999999329447746;
        "tint_intensity" = 0.0;
      };
    };
  };
}

{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/13-brightness.toml".source = (pkgs.formats.toml {}).generate "13-brightness.toml" {
      "brightness" = {
        "enable_ddcutil" = true;
      };
    };
  };
}

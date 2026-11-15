{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/17-location.toml".source = (pkgs.formats.toml {}).generate "17-location.toml" {
      "location" = {
        "address" = "Dinslaken";
      };
    };
  };
}

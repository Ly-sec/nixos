{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/32-dock.toml".source = (pkgs.formats.toml {}).generate "32-dock.toml" {
      "dock" = {
        "colorize_icons" = true;
        "concave_edge_corners" = true;
        "icon_size" = 26;
        "launcher_position" = "start";
        "pinned" = [
          "kitty"
          "dev.noctalia.luciole"
        ];
        "radius" = 12;
        "reserve_space" = false;
        "shadow" = false;
      };
    };
  };
}

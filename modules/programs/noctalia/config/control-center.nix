{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/31-control-center.toml".source = (pkgs.formats.toml {}).generate "31-control-center.toml" {
      "control_center" = {
        "hidden_tabs" = [
          "power"
          "network"
        ];
        "show_shortcut_labels" = false;
        "width" = 750;
        "shortcuts" = [
          {
            "type" = "notification";
          }
          {
            "type" = "clipboard";
          }
          {
            "type" = "nightlight";
          }
          {
            "type" = "wallpaper";
          }
        ];
      };
    };
  };
}

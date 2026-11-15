{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/15-interaction.toml".source = (pkgs.formats.toml {}).generate "15-interaction.toml" {
      "hot_corners" = {
        "delay_ms" = 2000;
        "enabled" = true;
      };
      "keybinds" = {
        "tab_previous" = [
          "Shift+ISO_Left_Tab"
        ];
        "validate" = [
          "Return"
          "KP_Enter"
        ];
      };
    };
  };
}

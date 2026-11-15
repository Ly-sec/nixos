{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/16-idle.toml".source = (pkgs.formats.toml {}).generate "16-idle.toml" {
      "idle" = {
        "behavior_order" = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        "behavior" = {
          "lock" = {
            "action" = "lock";
            "enabled" = false;
            "timeout" = 5.0;
          };
          "lock-and-suspend" = {
            "action" = "lock_and_suspend";
            "enabled" = false;
            "timeout" = 5.0;
          };
          "screen-off" = {
            "action" = "screen_off";
            "enabled" = false;
            "timeout" = 10.0;
          };
        };
      };
    };
  };
}

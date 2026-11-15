{config, ...}: {
  flake.modules.nixos."host-display-niri" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."host-display-niri"];
  };
  flake.modules.homeManager."host-display-niri" = {lib, ...}: {
    programs.niri.settings = {
      outputs = {
        "DP-1" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 359.979;
          };
          scale = 1.0;
        };
        "DP-2" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 164.917;
          };
          #transform.rotation = 90;
          scale = 1.0;
        };
      };
      workspaces.vesktop = {
        open-on-output = "DP-2";
      };
      window-rules = lib.mkBefore [
        {
          matches = [
            {
              at-startup = true;
              app-id = "vesktop";
            }
          ];
          open-on-output = "DP-2";
          open-on-workspace = "vesktop";
          open-maximized = true;
        }
      ];
    };
  };
}

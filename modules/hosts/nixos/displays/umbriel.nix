{config, ...}: {
  flake.modules.nixos."host-display-umbriel" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."host-display-umbriel"];
  };
  flake.modules.homeManager."host-display-umbriel" = {lib, ...}: {
    programs.umbriel.settings.output = {
      "DP-1" = {
        mode = "2560x1440@359.979";
        position = [
          0
          0
        ];
        scale = 1.0;
        transform = "normal";
        vrr = "disabled";
        hdr = "auto";
        workspaces = 9;
      };

      "DP-2" = {
        mode = "1920x1080@164.917";
        position = [
          2560
          0
        ];
        scale = 1.0;
        transform = "normal";
        workspaces = "dynamic";
      };
    };

    programs.umbriel.settings.workspace = [
      {
        output = "DP-1";
        index = 5;
        layout.mode = "stacking";
      }
      {
        output = "DP-1";
        index = 8;
        layout.mode = "master";
      }
      {
        output = "DP-1";
        index = 9;
        layout.mode = "dwindle";
      }
      {
        output = "DP-2";
        name = "vesktop";
      }
    ];

    programs.umbriel.settings.window_rule = lib.mkAfter [
      {
        match.app_id = "^vesktop$";
        default_workspace = "vesktop";
        default_focused = false;
        default_maximize = true;
        default_output = "DP-2";
      }
      {
        match.title = "^notificationtoasts_.+_desktop";
        default_position = {
          x = 12;
          y = 12;
          anchor = "bottom_right";
        };
        default_output = "DP-1";
        default_focused = false;
      }
    ];
  };
}

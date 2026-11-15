{
  flake.modules.homeManager."desktop-umbriel" = {...}: {
    programs.umbriel.settings = {
      layer_rule = [
        {
          match.namespace = ''^noctalia-(bar-[^"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^"]*)$'';
          blur = true;
          blur_ignore_alpha = 0.5;
          blur_popups = true;
        }
      ];

      window_rule = [
        # {
        #   match.app_id = "^(steam_app_[0-9]+|gamescope)$";
        #   hdr = "on";
        # }
        # {
        #   match.app_id = "^Minecraft[*]$";
        #   hdr = "fullscreen";
        # }
        {
          match.app_id = "^helium$";
          default_maximize = true;
        }
        {
          match.title = "^(Picture-in-Picture|Picture in picture)$";
          default_floating = true;
          default_maximize = false;
          default_position = {
            x = 20;
            y = 20;
            anchor = "bottom_right";
          };
        }

        {
          match.app_id = "^dev\\.noctalia\\.UmbrielSharePicker$";
          default_floating = true;
          default_floating_size_px = {
            width = 800;
            height = 600;
          };
        }
      ];
    };
  };
}

{
  programs.umbriel.settings = {
    effects = {
      border = "";
      window = "";
      screen = "";
      cursor = "";
      max_fps = 0;
      in_capture = false;
    };

    animation = {
      enabled = true;
      duration_ms = 195;
      curve = "cinematic";

      beziers = {
        cinematic = [
          0.16
          0.84
          0.24
          1.0
        ];
        window_flow = [
          0.20
          0.75
          0.25
          1.0
        ];
        workspace_flow = [
          0.20
          0.80
          0.24
          1.0
        ];
      };

      springs.apparition = {
        damping = 0.70;
        stiffness = 240;
      };

      windows_in = {
        enabled = true;
        effect = "";
        curve = "apparition";
      };

      windows_out = {
        enabled = true;
        effect = "";
        duration_ms = 165;
        curve = "easeoutcubic";
      };

      windows_move = {
        enabled = true;
        effect = "";
        duration_ms = 195;
        curve = "window_flow";
      };

      workspaces = {
        enabled = true;
        effect = "";
        duration_ms = 225;
        curve = "workspace_flow";
      };

      overview = {
        enabled = true;
        effect = "";
        duration_ms = 280;
        curve = "cinematic";
        workspace_curve = "workspace_flow";
      };

      scratchpad = {
        enabled = true;
        effect = "";
        duration_ms = 215;
        curve = "easeinoutcubic";
        dim = 0.42;
        blur = false;
        scale = 0.0;
        maximize = false;
        fullscreen = false;
      };

      border = {
        enabled = false;
        effect = "";
      };

      layers = {
        enabled = true;
        effect = "";
        duration_ms = 175;
        curve = "easeoutcubic";
      };

      dim_unfocused = {
        enabled = false;
        effect = "";
      };
    };
  };
}

{ ... }:

{
  programs.umbriel.settings.animation = {
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
        0.25
        0.46
        0.35
        1.0
      ];
      workspace_flow = [
        0.38
        0.0
        0.22
        1.0
      ];
    };

    springs.apparition = {
      damping = 0.70;
      stiffness = 240;
    };

    windows_in = {
      enabled = true;
      duration_ms = 205;
      curve = "apparition";
      style = "popin";
      scale = 0.72;
    };

    windows_out = {
      enabled = true;
      duration_ms = 165;
      curve = "easeoutcubic";
      style = "fade";
    };

    windows_move = {
      enabled = true;
      duration_ms = 195;
      curve = "window_flow";
    };

    workspaces = {
      enabled = true;
      duration_ms = 225;
      curve = "workspace_flow";
    };

    overview = {
      enabled = true;
      duration_ms = 280;
      curve = "cinematic";
    };

    scratchpad = {
      enabled = true;
      duration_ms = 215;
      curve = "easeinoutcubic";
      dim = 0.42;
      blur = false;
      scale = 0.0;
      maximize = false;
      fullscreen = false;
    };

    border.enabled = false;

    layers = {
      enabled = true;
      duration_ms = 175;
      curve = "easeoutcubic";
    };
  };
}

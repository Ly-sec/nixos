{ ... }:

{
  programs.niri.settings.animations = {
    workspace-switch.kind.spring = {
      damping-ratio = 1.0;
      stiffness = 1000;
      epsilon = 0.0001;
    };
    window-open.kind.easing = {
      duration-ms = 200;
      curve = "ease-out-quad";
    };
    window-close.kind.easing = {
      duration-ms = 200;
      curve = "ease-out-cubic";
    };
    horizontal-view-movement.kind.spring = {
      damping-ratio = 1.0;
      stiffness = 900;
      epsilon = 0.0001;
    };
    window-movement.kind.spring = {
      damping-ratio = 1.0;
      stiffness = 800;
      epsilon = 0.0001;
    };
    window-resize.kind.spring = {
      damping-ratio = 1.0;
      stiffness = 1000;
      epsilon = 0.0001;
    };
    config-notification-open-close.kind.spring = {
      damping-ratio = 0.6;
      stiffness = 1200;
      epsilon = 0.001;
    };
    screenshot-ui-open.kind.easing = {
      duration-ms = 300;
      curve = "ease-out-quad";
    };
    overview-open-close.kind.spring = {
      damping-ratio = 1.0;
      stiffness = 900;
      epsilon = 0.0001;
    };
  };
}

{ ... }:

{
  programs.umbriel.settings = {
    layout = {
      mode = "scrolling";
      gap = 5;
      width_presets = [
        0.333
        0.5
        0.667
      ];
      scrolling = {
        default_width_fraction = 0.5;
        center_underfull_strip = false;
      };
    };

    workspaces.back_and_forth = true;

    workspace = [
      {
        output = "DP-1";
        index = 9;
        layout.mode = "dwindle";
      }
    ];
  };
}

{ ... }:

{
  programs.umbriel.settings = {
    layout = {
      mode = "scrolling";
      gap = 5;
      extent_presets = [
        0.333
        0.5
        0.667
      ];
      scrolling = {
        default_extent_fraction = 0.5;
        center_underfull_strip = false;
      };
    };

    workspaces.back_and_forth = true;

    workspace = [
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
      {
        output = "DP-2";
        name = "fluxer";
      }
    ];
  };
}

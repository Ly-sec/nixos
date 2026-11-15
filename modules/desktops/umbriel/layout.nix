{
  flake.modules.homeManager."desktop-umbriel" = {...}: {
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
        stacking.drop_zones = true;
      };

      workspaces.back_and_forth = true;
    };
  };
}

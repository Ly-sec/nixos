{ ... }:

{
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
    };
  };
}

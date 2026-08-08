{ ... }:

{
  programs.niri.settings = {
    window-rules = [
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
      {
        matches = [
          {
            at-startup = true;
            app-id = "fluxer-canary";
          }
        ];
        open-on-output = "DP-2";
        open-on-workspace = "fluxer";
        open-maximized = true;
      }
      {
        matches = [ { app-id = "zen"; } ];
        open-on-workspace = "browser";
        open-maximized = true;
      }
      {
        matches = [
          {
            app-id = "zen";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }
      {
        matches = [ { } ];
        geometry-corner-radius = {
          top-left = 14.0;
          top-right = 14.0;
          bottom-left = 14.0;
          bottom-right = 14.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [ { app-id = "^dev\\.lemmy\\.swash$"; } ];
        open-floating = true;
      }
      {
        # niri-screenshare GTK picker dialog
        matches = [
          { app-id = "^io\\.github\\.niri\\.screenshare\\.picker$"; }
          { app-id = "^niri-screenshare-picker$"; }
          { title = "^Screen Sharing$"; }
        ];
        open-floating = true;
      }
    ];

    layer-rules = [
      {
        matches = [ { namespace = "^noctalia-(main|notifications|dock)$"; } ];
      }
      {
        matches = [ { namespace = "^noctalia-wallpaper"; } ];
        place-within-backdrop = true;
      }
    ];
  };
}

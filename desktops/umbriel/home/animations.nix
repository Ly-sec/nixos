{ config, lib, ... }:

let
  # Change this one value to switch the complete Umbriel effect setup.
  activeSetup = "sakura-overdrive";

  bundledReveal = "${config.programs.umbriel.package}/share/umbriel/effects/animation/reveal/effect.toml";
  sakuraEffects = "${./effects/sakura-overdrive}/effect.toml";

  setups = {
    classic = {
      files = [ bundledReveal ];
      appearance.outer_border_width = 13;
      effects = {
        border = "";
        window = "";
        screen = "";
        cursor = "";
        max_fps = 0;
        in_capture = false;
      };
      animation = {
        windows_in.effect = "reveal";
        windows_out.effect = "reveal";
      };
    };

    sakura-overdrive = {
      files = [ sakuraEffects ];
      appearance.outer_border_width = 0;
      effects = {
        border = "sakura-vine";
        window = "";
        screen = "sakura-dream";
        cursor = "mahou-twinkle";
        max_fps = 60;
        in_capture = false;
      };
      animation = {
        windows_in = {
          effect = "sakura-materialize";
          duration_ms = 620;
          curve = "linear";
        };
        windows_out = {
          effect = "sakura-materialize";
          duration_ms = 500;
          curve = "linear";
        };
        windows_move = {
          duration_ms = 240;
          curve = "window_flow";
          effect = "sakura-rush";
        };
        workspaces.effect = "sakura-shift";
        scratchpad.effect = "magic-summon";
        border = {
          enabled = true;
          duration_ms = 210;
          curve = "linear";
          effect = "sakura-focus";
        };
        windows_drag.physics = true;
      };
    };
  };

  selected = setups.${activeSetup} or (throw "unknown Umbriel effect setup: ${activeSetup}");

  baseAnimation = {
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
      curve = "apparition";
    };

    windows_out = {
      enabled = true;
      duration_ms = 165;
      curve = "easeoutcubic";
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
      workspace_curve = "workspace_flow";
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
in

{
  programs.umbriel.settings = {
    include.files = selected.files;
    appearance = selected.appearance;
    effects = selected.effects;
    animation = lib.recursiveUpdate baseAnimation selected.animation;
  };
}

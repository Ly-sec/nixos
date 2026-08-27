{ ... }:

{
  programs.umbriel.settings.input = {
    middle_click_paste = true;

    keyboard = {
      layout = "de";
      variant = "";
      repeat_rate = 25;
      repeat_delay = 600;
    };

    touchpad = {
      tap = true;
      natural_scroll = true;
    };

    mouse = {
      accel_profile = "flat";
      sensitivity = 0.4;
      scroll_wheel_step = 60;
    };

    cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
      hardware_cursor = true;
      hide_when_typing = false;
      hide_timeout_ms = 30000;
    };

    focus.follows_mouse = true;
  };
}

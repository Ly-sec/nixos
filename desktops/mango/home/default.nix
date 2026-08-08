{
  pkgs,
  lib,
  config,
  ...
}:

let
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
  nautilus = "${pkgs.nautilus}/bin/nautilus";
  noctalia = lib.getExe config.lysec.noctaliaPackage;
  wpctl = "${pkgs.wireplumber}/bin/wpctl";

  tagBinds = lib.concatMapStrings (i: ''
    bind=SUPER,${toString i},view,${toString i},0
    bind=SUPER+CTRL,${toString i},tag,${toString i},0
  '') (lib.range 1 9);

  tagRules = lib.concatMapStrings (i: ''
    tagrule=id:${toString (i - 1)},layout_name:tile
  '') (lib.range 1 9);
in
{
  xdg.configFile."mango/config.conf".text = ''
    # Keyboard
    repeat_rate=25
    repeat_delay=600
    numlockon=1
    xkb_rules_layout=de

    # Trackpad
    tap_to_click=1
    tap_and_drag=1
    drag_lock=1
    trackpad_natural_scrolling=1
    disable_while_typing=1

    # Mouse
    mouse_natural_scrolling=1

    # Appearance
    gappih=5
    gappiv=5
    gappoh=10
    gappov=10
    borderpx=4
    rootcolor=0x201b14ff
    bordercolor=0x444444ff
    focuscolor=0xc9b890ff
    blur=1
    blur_layer=1
    blur_optimized=0
    blur_params_num_passes=1
    blur_params_radius=1
    blur_params_noise=0.02
    blur_params_brightness=0.9
    blur_params_contrast=0.9
    blur_params_saturation=1.1

    monitorrule=name:^DP-1$,width:2560,height:1440,refresh:360,x:0,y:10

    smartgaps=0
    no_border_when_single=0
    sloppyfocus=1
    warpcursor=1
    focus_on_activate=1

    # Layout: all tags go tile
    ${tagRules}

    # Key Binds

    # Terminal and apps
    bind=SUPER,Return,spawn,${ghostty}
    bind=SUPER+CTRL,Return,spawn,${noctalia} msg panel-toggle launcher
    bind=ALT,Tab,spawn,${noctalia} msg window-switcher
    bind=SUPER,B,spawn,${firefox}
    bind=SUPER,E,spawn,${nautilus}

    # Audio
    bind=NONE,XF86AudioMute,spawn,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind=SUPER,Delete,spawn,${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bind=SUPER,Page_Up,spawn,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+
    bind=SUPER,Page_Down,spawn,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05-

    # Window management
    bind=SUPER,Q,killclient,
    bind=SUPER,Escape,quit
    bind=CTRL+ALT,Delete,quit
    bind=SUPER,F,togglefullscreen,
    bind=SUPER,T,togglefloating,

    # Focus direction
    bind=SUPER,Left,focusdir,left
    bind=SUPER,H,focusdir,left
    bind=SUPER,Right,focusdir,right
    bind=SUPER,L,focusdir,right
    bind=SUPER,Up,focusdir,up
    bind=SUPER,K,focusdir,up
    bind=SUPER,Down,focusdir,down
    bind=SUPER,J,focusdir,down
    bind=SUPER,F1,focusstack,next

    # Swap / move windows
    bind=SUPER+CTRL,Left,exchange_client,left
    bind=SUPER+CTRL,H,exchange_client,left
    bind=SUPER+CTRL,Right,exchange_client,right
    bind=SUPER+CTRL,L,exchange_client,right
    bind=SUPER+CTRL,Up,exchange_client,up
    bind=SUPER+CTRL,K,exchange_client,up
    bind=SUPER+CTRL,Down,exchange_client,down
    bind=SUPER+CTRL,J,exchange_client,down

    # Gaps
    bind=SUPER+CTRL,comma,incgaps,-1
    bind=SUPER+CTRL,period,incgaps,1

    # Switch layout
    bind=SUPER,Space,switch_layout

    # Screenshot
    bind=CTRL+ALT,1,spawn,${noctalia} msg screenshot-region

    # Reload config
    bind=SUPER+SHIFT,C,reload_config

    # Tags (workspaces)
    ${tagBinds}
  '';
}

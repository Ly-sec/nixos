{ pkgs, vars, ... }:

let
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
in
{
  xdg.configFile."labwc/autostart".source =
    pkgs.writeShellScript "labwc-autostart" ''
      ${vars.noctalia} &
    '';

  xdg.configFile."labwc/rc".text = ''
    keyboard {
      layout de
      numlock enable
    }

    mouse {
      natural-scroll yes
    }

    bind Super_L Return {
      action Execute
      command ${ghostty}
    }

    bind Super_L b {
      action Execute
      command ${firefox}
    }

    bind Super_L Control_R Return {
      action Execute
      command ${vars.noctalia} msg panel-toggle launcher
    }

    bind Super_L q {
      action Close
    }
  '';
}

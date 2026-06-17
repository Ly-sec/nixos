{ pkgs, vars, ... }:

let
  noctalia = import ../../../lib/noctalia.nix { inherit pkgs vars; };
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
in
{
  xdg.configFile."labwc/autostart".source =
    pkgs.writeShellScript "labwc-autostart" ''
      ${noctalia.autostart}/bin/noctalia-autostart &
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
      command ${noctalia.toggleLauncher}/bin/noctalia-toggle-launcher
    }

    bind Super_L q {
      action Close
    }
  '';
}

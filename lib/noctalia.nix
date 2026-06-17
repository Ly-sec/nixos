{ pkgs, vars }:

let
  noctalia = vars.noctalia;
in
{
  bin = noctalia;

  autostart = pkgs.writeShellApplication {
    name = "noctalia-autostart";
    runtimeInputs = [ pkgs.util-linux ];
    text = ''
      exec flock -xn "/run/user/$(id -u)/noctalia-autostart.lock" ${noctalia}
    '';
  };

  toggleLauncher = pkgs.writeShellApplication {
    name = "noctalia-toggle-launcher";
    text = ''
      exec ${noctalia} msg panel-toggle launcher
    '';
  };
}

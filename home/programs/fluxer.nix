{ pkgs, inputs, config, lib, ... }:

let
  fluxer = import ../../lib/fluxer.nix { inherit pkgs inputs; };
  brokenAutostart = "${config.xdg.configHome}/autostart/fluxer-canary.desktop.backup";
in
{
  home.packages = [ fluxer ];

  # Fluxer rewrites this with a broken direct opt/ path; keep it hidden since niri starts it.
  xdg.configFile."autostart/fluxer-canary.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
  
  systemd.user.services.fluxer-autostart-cleanup = {
    Unit = {
      Description = "Remove fluxer self-written broken XDG autostart";
      Before = [ "xdg-desktop-autostart.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/rm -f ${brokenAutostart}";
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "xdg-desktop-autostart.target" ];
  };

  home.activation.removeFluxerBrokenAutostart = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -f ${brokenAutostart}
  '';
}

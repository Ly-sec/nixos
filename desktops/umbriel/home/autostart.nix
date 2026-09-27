{
  pkgs,
  lib,
  config,
  ...
}:

let
  browser = config.home.sessionVariables.BROWSER;
  noctalia = lib.getExe pkgs.noctalia;
in
{
  programs.umbriel.settings.general.autostart = [
    noctalia
    browser
    "sleep 4; ${pkgs.vesktop}/bin/vesktop"
  ];
}

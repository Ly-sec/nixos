{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  niriScreenshare = inputs.niri-screenshare.packages.${system}.default;

  gtkPortals = [
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gtk
  ];

  # gtk portal covers file chooser / open-uri; niri-screenshare does ScreenCast.
  niriPortals = gtkPortals ++ [
    niriScreenshare
  ];

  kdePortals = with pkgs.kdePackages; [
    xdg-desktop-portal-kde
  ];

  desktop = config.lysec.desktop;
  isPlasma = desktop == "plasma";
  isNiri = desktop == "niri";
in
{
  xdg.portal = {
    enable = true;

    config =
      {
        common =
          if isPlasma then
            {
              default = "kde";
            }
          else
            {
              default = "gtk";
            };
      }
      // lib.optionalAttrs isNiri {
        # ScreenCast uses niri-screenshare; other interfaces fall through to common/gtk.
        niri = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "niri";
        };
      };

    xdgOpenUsePortal = true;

    extraPortals =
      if isPlasma then
        kdePortals
      else if isNiri then
        niriPortals
      else
        gtkPortals;
  };

  # Prefer the GTK picker UI when the portal backend is built with --features picker.
  # `niri` must be on PATH — the service otherwise can't list outputs/windows.
  systemd.user.services.niri-screenshare = lib.mkIf isNiri {
    path = [ config.programs.niri.package ];
    environment = {
      NIRI_SCREENSHARE_PICKER = "1";
    };
  };
}

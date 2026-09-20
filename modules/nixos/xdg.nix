{
  pkgs,
  config,
  ...
}:

let
  gtkPortals = [
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gtk
  ];

  kdePortals = with pkgs.kdePackages; [
    xdg-desktop-portal-kde
  ];

  desktop = config.lysec.desktop;
  isPlasma = desktop == "plasma";
in
{
  xdg.portal = {
    enable = true;

    config.common =
      if isPlasma then
        {
          default = "kde";
        }
      else
        {
          default = "gtk";
        };

    xdgOpenUsePortal = true;

    extraPortals = if isPlasma then kdePortals else gtkPortals;
  };
}

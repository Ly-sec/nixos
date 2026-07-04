{ pkgs, desktop, lib, ... }:

let
  gnomePortals = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  kdePortals = with pkgs.kdePackages; [
    xdg-desktop-portal-kde
  ];
in
{
  xdg.portal = {
    enable = true;

    config.common = if desktop == "plasma" then {
      default = "kde";
    } else {
      # Niri / GNOME-based portal stack
      default = "gnome";

      # IMPORTANT: do NOT override OpenURI or AppChooser
      # Let xdg-desktop-portal-gnome handle it
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      "org.freedesktop.impl.portal.Screenshot" = "gnome";
      "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
    };

    # IMPORTANT CHANGE:
    # Portal is still useful for sandboxed apps (flatpak, etc)
    xdgOpenUsePortal = true;

    extraPortals = if desktop == "plasma" then kdePortals else gnomePortals;
  };
}
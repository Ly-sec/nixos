{ pkgs, ... }:

{
  hardware.graphics.enable = true;

  niri-flake.cache.enable = true;
  programs.niri.enable = true;

  # Required for XWayland support under Niri.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };
}

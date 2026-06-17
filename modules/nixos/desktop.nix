{ pkgs, ... }:

{
  hardware.graphics.enable = true;

  niri-flake.cache.enable = true;
  programs.niri.enable = true;

  systemd.user.services.niri-flake-polkit.enable = false;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };
}

{ pkgs, ... }:

{
  hardware.graphics.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };
}

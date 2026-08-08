{ pkgs, ... }:

{
  hardware.graphics.enable = true;

  # Home Manager gtk / dconfSettings need this on every compositor
  programs.dconf.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };
}

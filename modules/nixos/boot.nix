{ inputs, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth = {
    enable = true;
    theme = "noctalia";
    themePackages = [
      inputs.noctalia-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
  };
}

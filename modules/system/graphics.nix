{
  nixos.base = {pkgs, ...}: {
    hardware.graphics.enable = true;
    environment.systemPackages = [pkgs.mesa pkgs.libva];
  };
}

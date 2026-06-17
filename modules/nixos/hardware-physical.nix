{ pkgs, ... }:

{
  services.udev.packages = [ pkgs.rwedid ];

  boot.kernelParams = [ "video=DP-1:2560x1440@360" ];
  boot.kernelModules = [ "i2c-dev" ];
  boot.initrd.availableKernelModules = [ "i2c-dev" ];

  services.xserver.videoDrivers = [ "amdgpu" ];
}

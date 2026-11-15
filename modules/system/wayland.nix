{
  nixos.base = {pkgs, ...}: {
    security.polkit.enablePkexecWrapper = true;
    hardware.enableRedistributableFirmware = true;
    services.accounts-daemon.enable = true;
    environment.systemPackages = [pkgs.xwayland];
  };
}

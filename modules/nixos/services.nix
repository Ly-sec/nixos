{ pkgs, ... }:

{
  security.polkit.enablePkexecWrapper = true;

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;

  services.dbus = {
    enable = true;
    packages = with pkgs; [ bluez ];
  };

  services.accounts-daemon.enable = true;

  services.power-profiles-daemon.enable = true;
  services.printing.enable = false;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
}

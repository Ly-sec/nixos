{
  nixos.base = {pkgs, ...}: {
    hardware.bluetooth.enable = true;
    services.dbus = {
      enable = true;
      packages = [pkgs.bluez];
    };
    environment.systemPackages = [pkgs.bluez];
  };
}

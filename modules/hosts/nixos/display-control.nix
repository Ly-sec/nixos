{
  flake.modules.nixos.host-nixos = {pkgs, ...}: {environment.systemPackages = [pkgs.ddcutil];};
}

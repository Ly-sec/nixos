{
  flake.modules.nixos."photocraft" = {pkgs, ...}: {environment.systemPackages = [pkgs.photocraft];};
}

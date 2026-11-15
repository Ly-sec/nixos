{
  flake.modules.nixos."media-tools" = {pkgs, ...}: {environment.systemPackages = [pkgs.ffmpeg];};
}

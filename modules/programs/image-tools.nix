{
  flake.modules.homeManager."image-tools" = {pkgs, ...}: {home.packages = [pkgs.imagemagick];};
}

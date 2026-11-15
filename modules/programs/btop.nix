{
  flake.modules.homeManager."btop" = {pkgs, ...}: {home.packages = [pkgs.btop];};
}

{
  flake.modules.homeManager."heroic" = {pkgs, ...}: {home.packages = [pkgs.heroic];};
}

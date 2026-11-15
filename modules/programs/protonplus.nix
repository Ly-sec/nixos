{
  flake.modules.homeManager."protonplus" = {pkgs, ...}: {home.packages = [pkgs.protonplus];};
}

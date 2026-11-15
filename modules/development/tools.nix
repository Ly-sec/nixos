{
  flake.modules.homeManager.development = {pkgs, ...}: {home.packages = [pkgs.just];};
}

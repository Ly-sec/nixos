{
  flake.modules.homeManager.development = {pkgs, ...}: {home.packages = [pkgs.nim pkgs.nimble];};
}

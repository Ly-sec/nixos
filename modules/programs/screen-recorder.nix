{
  flake.modules.homeManager."screen-recorder" = {pkgs, ...}: {home.packages = [pkgs.gpu-screen-recorder];};
}

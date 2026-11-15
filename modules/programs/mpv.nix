{
  flake.modules.homeManager."mpv" = {pkgs, ...}: {home.packages = [pkgs.mpv];};
}

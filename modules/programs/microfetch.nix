{
  flake.modules.homeManager."microfetch" = {pkgs, ...}: {
    home.packages = [pkgs.microfetch];
  };
}

{
  flake.modules.homeManager."vesktop" = {pkgs, ...}: {
    home.packages = [pkgs.vesktop];
  };
}

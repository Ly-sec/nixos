{
  flake.modules.homeManager."prismlauncher" = {pkgs, ...}: {home.packages = [pkgs.prismlauncher];};
}

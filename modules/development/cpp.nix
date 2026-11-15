{
  flake.modules.homeManager.development = {pkgs, ...}: {home.packages = [pkgs.gcc16 pkgs.llvmPackages_23.clang-tools];};
}

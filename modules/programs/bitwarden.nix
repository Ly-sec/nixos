{
  flake.modules.homeManager."bitwarden" = {pkgs, ...}: {home.packages = [pkgs.bitwarden-cli];};
}

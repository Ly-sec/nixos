{config, ...}: {
  flake.modules.nixos.cli = {pkgs, ...}: {
    home-manager.sharedModules = [config.flake.modules.homeManager.cli];
    environment.systemPackages = [pkgs.wget];
  };
  flake.modules.homeManager."cli" = {pkgs, ...}: {home.packages = [pkgs.jq pkgs.eza pkgs.ripgrep pkgs.tree pkgs.unzip];};
}

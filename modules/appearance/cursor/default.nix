{config, ...}: {
  flake.modules.nixos.cursor = {
    imports = [config.flake.modules.generic.cursor];
    home-manager.sharedModules = [config.flake.modules.homeManager.cursor];
  };
  flake.modules.homeManager.cursor.imports = [config.flake.modules.generic.cursor];
}

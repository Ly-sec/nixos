{
  config,
  lib,
  ...
}: {
  options = {
    nixos.base = lib.mkOption {
      type = lib.types.deferredModule;
      default = {};
      description = "Shared operating-system defaults for the desktop hosts.";
    };
    homeManager.base = lib.mkOption {
      type = lib.types.deferredModule;
      default = {};
      description = "Shared user-session defaults attached by the system base.";
    };
  };
  config.nixos.base.home-manager.sharedModules = [config.homeManager.base];
}

{
  inputs,
  config,
  ...
}: let
  host = config.lysec;
  m = config.flake.modules;
in {
  nixos.base = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      overwriteBackup = true;
      sharedModules = [
        m.generic.lysec-options
        {lysec = host // {desktop = config.lysec.desktop;};}
      ];
    };
    systemd.services."home-manager-${config.lysec.username}".serviceConfig.TimeoutStartSec =
      lib.mkForce "30m";
  };
}

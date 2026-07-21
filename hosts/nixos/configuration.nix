{ config, ... }:

{
  imports = [
    ../../hardware/hardware-configuration.nix
    ../../hardware/storage.nix
    ../../modules/nixos/hardware-physical.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/greeter.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/xdg.nix
    ../../modules/nixos/environment.nix
    ../../modules/nixos/steam.nix
  ];

  networking.hostName = config.lysec.hostname;
  system.stateVersion = config.lysec.stateVersion;
}

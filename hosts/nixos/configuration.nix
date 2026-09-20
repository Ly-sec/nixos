{
  config,
  desktop,
  host,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
    ../../modules/lysec
    ../../modules/nixos
    (../../desktops + "/${desktop}/nixos.nix")
  ];

  lysec = host;
  networking.hostName = config.lysec.hostname;
  system.stateVersion = config.lysec.stateVersion;
}

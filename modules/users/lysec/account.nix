{
  flake.modules.nixos."user-lysec" = {
    config,
    pkgs,
    ...
  }: {
    users.groups.i2c = {};

    users.users.${config.lysec.username} = {
      isNormalUser = true;
      description = config.lysec.username;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "input"
        "plugdev"
        "i2c"
        "bluetooth"
      ];
    };
  };
}

{ vars, pkgs, ... }:

{
  users.groups.i2c = { };

  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.username;
    shell = pkgs.fish;
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

  programs.fish.enable = true;
}

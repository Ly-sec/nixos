{
  flake.modules.nixos.host-nixos = {imports = [./_hardware-configuration.nix];};
}

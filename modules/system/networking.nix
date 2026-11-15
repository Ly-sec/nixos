{
  nixos.base = {...}: {
    networking.networkmanager.enable = true;
  };
}

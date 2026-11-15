{
  nixos.base = {
    services.printing.enable = false;
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}

{
  inputs,
  ...
}:

{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    # Keep the manager enabled to uninstall previously managed applications.
    packages = [ ];
  };
}

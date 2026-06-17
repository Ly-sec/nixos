{ inputs, pkgs, ... }:

{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  niri-flake.cache.enable = true;
  programs.niri.enable = true;

  programs.niri.package =
    (inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable).overrideAttrs (_: {
      doCheck = false;
    });

  systemd.user.services.niri-flake-polkit.enable = false;
}

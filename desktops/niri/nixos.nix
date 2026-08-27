{ inputs, pkgs, ... }:

{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  niri-flake.cache.enable = true;
  programs.niri.enable = true;

  # niri-flake's package still requires the retired libdisplay-info 0.2 ABI.
  # Use Nixpkgs' package instead; it follows the current libdisplay-info ABI.
  programs.niri.package = pkgs.niri;

  systemd.user.services.niri-flake-polkit.enable = false;
}

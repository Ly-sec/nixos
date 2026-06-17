{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];

  systemd.services.nix-daemon.path = [ pkgs.git ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
}

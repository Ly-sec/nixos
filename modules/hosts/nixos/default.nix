{
  inputs,
  config,
  lib,
  ...
}: let
  host = config.lysec;
  m = config.flake.modules;
  base = config.nixos.base;
  desktops = import ../../desktops/_metadata.nix;
  makeSystem = desktop:
    inputs.nixpkgs.lib.nixosSystem {
      modules =
        [
          m.nixos.host-nixos
          m.nixos."desktop-${desktop}"
          {lysec = host // {inherit desktop;};}
        ]
        ++ lib.optionals (desktop != "plasma") [
          m.nixos.noctalia-greeter
          m.nixos.host-greeter
        ]
        ++ lib.optionals (builtins.elem desktop ["umbriel" "niri" "labwc" "mango"]) [
          m.nixos."host-display-${desktop}"
        ];
    };
in {
  flake.nixosConfigurations.nixos = makeSystem host.desktop;
  flake.lib.configurationForDesktop = desktop: makeSystem (desktops.assertValid desktop);
  flake.modules.nixos.host-nixos = {config, ...}: {
    imports = with m.nixos; [
      m.generic.lysec-options
      base
      user-lysec
      secrets
      gtk
      cursor
      fish
      git
      cli
      firefox
      helium
      sonora
      luciole
      noctalia
      noctalia-plymouth
      noctalia-greeter-package
      steam
      photocraft
      media-tools
    ];
    nixpkgs.hostPlatform = config.lysec.system;
    networking.hostName = config.lysec.hostname;
    system.stateVersion = config.lysec.stateVersion;
  };
}

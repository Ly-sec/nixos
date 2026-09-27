{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=v0.7.0";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-desktop-portal-umbriel = {
      url = "github:noctalia-dev/xdg-desktop-portal-umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonora = {
      url = "path:/mnt/storage/GitHub/lysec/sonora";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    doomemacs = {
      url = "git+https://github.com/doomemacs/doomemacs.git?submodules=1";
      flake = false;
    };

    swash = {
      url = "github:ItsLemmy/swash";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel = {
      url = "github:noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.xdg-desktop-portal-umbriel.follows = "xdg-desktop-portal-umbriel";
    };

    noctalia-greeter = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agenix,
      ...
    }@inputs:

    let
      host = import ./hosts/nixos/settings.nix;
      inherit (host) desktop system username;
    in
    {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs host desktop;
        };

        modules = [
          agenix.nixosModules.default
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager

          (
            { lib, ... }:
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                overwriteBackup = true;
                extraSpecialArgs = {
                  inherit inputs desktop;
                };
                sharedModules = [
                  ./modules/lysec
                  { lysec = host; }
                ];

                users.${username} = import ./home/default.nix;
              };

              systemd.services."home-manager-${username}".serviceConfig.TimeoutStartSec =
                lib.mkForce "30m";
            }
          )
        ];
      };
    };
}

{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fluxer = {
      url = "github:Hy4ri/fluxer-flake";
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
      url = "path:/mnt/storage/GitHub/noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-screenshare = {
      url = "path:/mnt/storage/GitHub/lysec/niri-screenshare";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-desktop-portal-umbriel = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/xdg-desktop-portal-umbriel";
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
      self,
      nixpkgs,
      home-manager,
      agenix,
      ...
    }@inputs:

    let
      lysec =
        (nixpkgs.lib.evalModules {
          modules = [ ./modules/lysec/settings.nix ];
        }).config.lysec;

      inherit (lysec) desktop;
    in
    {
      formatter = nixpkgs.legacyPackages.${lysec.system}.alejandra;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit (lysec) system;

        specialArgs = {
          inherit self inputs;
          inherit desktop;
        };

        modules = [
          ./modules/lysec
          agenix.nixosModules.default
          ./modules/nixos/agenix.nix
          ./hosts/nixos/configuration.nix

          (./desktops + "/${desktop}/nixos.nix")

          home-manager.nixosModules.home-manager

          (
            { ... }:
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                overwriteBackup = true;
                extraSpecialArgs = {
                  inherit self inputs;
                  inherit desktop;
                };
                sharedModules = [
                  ./modules/lysec
                ];

                users.${lysec.username} = import ./home/default.nix;
              };
            }
          )
        ];
      };
    };
}

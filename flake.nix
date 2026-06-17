{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fluxer = {
      url = "github:Hy4ri/fluxer-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nur
    , niri
    , spicetify-nix
    , fluxer
    , ...
    }@inputs:

    let
      vars = import ./vars.nix;
    in
    {
      formatter =
        nixpkgs.legacyPackages.${vars.system}.alejandra;

      nixosConfigurations.nixos =
        nixpkgs.lib.nixosSystem {
          system = vars.system;

          specialArgs = {
            inherit self inputs vars;
          };

          modules = [
            ./hosts/nixos/configuration.nix

            home-manager.nixosModules.home-manager

            niri.nixosModules.niri

            spicetify-nix.nixosModules.default

            {
              programs.niri.package =
                (inputs.niri.packages.${vars.system}.niri-unstable).overrideAttrs (_: {
                  doCheck = false;
                });

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit self inputs vars;
              };

              home-manager.users.${vars.username} =
                import ./home/default.nix;
            }
          ];
        };
    };
}

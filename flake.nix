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
      desktops = import ./lib/desktops.nix;

      baseVars = import ./vars.nix;
      # Gitignored files are not in the flake store; load from the checkout on disk.
      configDir =
        let
          env = builtins.getEnv "NIXOS_CONFIG";
        in
        if env != "" then env else "/home/${baseVars.username}/nixos";
      localVarsPath = /. + configDir + "/vars.local.nix";
      localVars =
        if builtins.pathExists localVarsPath then
          import localVarsPath
        else
          { };
      vars = baseVars // localVars;
      desktop = desktops.assertValid vars.desktop;
    in
    {
      formatter =
        nixpkgs.legacyPackages.${vars.system}.alejandra;

      nixosConfigurations.nixos =
        nixpkgs.lib.nixosSystem {
          system = vars.system;

          specialArgs = {
            inherit self inputs vars desktop;
          };

          modules = [
            ./hosts/nixos/configuration.nix

            (./desktops + "/${desktop}/nixos.nix")

            home-manager.nixosModules.home-manager

            spicetify-nix.nixosModules.default

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit self inputs vars desktop;
              };

              home-manager.users.${vars.username} =
                import ./home/default.nix;
            }
          ];
        };
    };
}

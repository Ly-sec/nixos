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
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

    waytator = {
      url = "github:ItsLemmy/waytator";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nur
    , niri
    , fluxer
    , waytator
    , noctalia
    , noctalia-greeter
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
      noctaliaPackage = noctalia.packages.${vars.system}.default;
    in
    {
      formatter =
        nixpkgs.legacyPackages.${vars.system}.alejandra;

      nixosConfigurations.nixos =
        nixpkgs.lib.nixosSystem {
          system = vars.system;

          specialArgs = {
            inherit self inputs vars desktop noctaliaPackage;
          };

          modules = [
            ./hosts/nixos/configuration.nix

            (./desktops + "/${desktop}/nixos.nix")

            home-manager.nixosModules.home-manager

            ({ ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.overwriteBackup = true;
              home-manager.extraSpecialArgs = {
                inherit self inputs vars desktop noctaliaPackage;
              };

              home-manager.users.${vars.username} =
                import ./home/default.nix;
            })
          ];
        };
    };
}

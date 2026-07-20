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
      noctalia,
      agenix,
      ...
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
      localVars = if builtins.pathExists localVarsPath then import localVarsPath else { };
      vars = baseVars // localVars;
      desktop = desktops.assertValid vars.desktop;
      noctaliaPackage = noctalia.packages.${vars.system}.default;
    in
    {
      formatter = nixpkgs.legacyPackages.${vars.system}.alejandra;

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit (vars) system;

        specialArgs = {
          inherit
            self
            inputs
            vars
            desktop
            noctaliaPackage
            ;
        };

        modules = [
          ./hosts/nixos/configuration.nix
          agenix.nixosModules.default
          ./modules/nixos/agenix.nix

          (./desktops + "/${desktop}/nixos.nix")

          home-manager.nixosModules.home-manager

          (_: {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              overwriteBackup = true;
              extraSpecialArgs = {
                inherit
                  self
                  inputs
                  vars
                  desktop
                  noctaliaPackage
                  ;
              };

              users.${vars.username} = import ./home/default.nix;
            };
          })
        ];
      };
    };
}

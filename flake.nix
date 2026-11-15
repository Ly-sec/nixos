{
  description = "My NixOS config";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";

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
      url = "path:/mnt/storage/GitHub/noctalia-dev/xdg-desktop-portal-umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonora = {
      url = "github:sonorahq/sonora";
      # Match the dependency graph used by Sonora's published binary cache.
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/c59305bab2065cfecc4944690d9eedbb56f3a9fa";
    };

    luciole = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/luciole";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-plymouth = {
      url = "github:VuiMuich/noctalia-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel = {
      url = "path:/mnt/storage/GitHub/noctalia-dev/umbriel";
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
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);
}

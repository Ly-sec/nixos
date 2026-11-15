{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos."noctalia" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."noctalia"];
    nixpkgs.overlays = [
      (final: _: {
        noctalia = final.callPackage (inputs.noctalia.outPath + "/nix/package.nix") {rev = "local";};
      })
    ];
  };
  flake.modules.homeManager.noctalia = {pkgs, ...}: {
    home.packages = [pkgs.noctalia];
    xdg.configFile = {
      "noctalia/palettes" = {
        source = ./palettes;
        recursive = true;
      };
    };
  };
}

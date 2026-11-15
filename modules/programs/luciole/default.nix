{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos."luciole" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."luciole"];
    nixpkgs.overlays = [
      (final: _: {
        luciole = inputs.luciole.packages.${final.stdenv.hostPlatform.system}.default.override {
          stdenv = final.llvmPackages_23.stdenv;
        };
      })
    ];
  };
}

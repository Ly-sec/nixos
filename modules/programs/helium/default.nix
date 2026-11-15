{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos."helium" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."helium"];
    nixpkgs.overlays = [
      (final: _: {
        helium-widevine = inputs.helium.packages.${final.stdenv.hostPlatform.system}.helium-widevine;
      })
    ];
  };
}

{inputs, ...}: {
  flake.modules.nixos.noctalia-greeter-package = {
    nixpkgs.overlays = [
      (final: _: {
        noctalia-greeter = inputs.noctalia-greeter.packages.${final.stdenv.hostPlatform.system}.default;
      })
    ];
  };
}

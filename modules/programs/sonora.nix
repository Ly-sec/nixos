{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.sonora = {
    home-manager.sharedModules = [config.flake.modules.homeManager.sonora];
    nix.settings = {
      substituters = ["https://sonora.cachix.org"];
      trusted-public-keys = [
        "sonora.cachix.org-1:qbPeDsvZPbwUWHpQS5Oe0bjz5oHAVscHem+MCzwrc9Q="
      ];
    };
  };
  flake.modules.homeManager."sonora" = {...}: {
    imports = [inputs.sonora.homeManagerModules.default];

    programs.sonora = {
      enable = true;
      settings.provider = "apple";
    };
  };
}

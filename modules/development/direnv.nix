{
  flake.modules.homeManager.development = {
    programs.direnv = {
      enable = true;
      enableFishIntegration = true;
      enableGitIntegration = true;
      nix-direnv.enable = true;
    };
  };
}

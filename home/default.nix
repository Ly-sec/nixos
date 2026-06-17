{ pkgs, inputs, lib, vars, ... }:

{
  imports = [
    ./niri/default.nix
    ./editors/vscode.nix
    ./programs/ghostty.nix
    ./programs/fastfetch.nix
    ./programs/firefox.nix
    ./programs/fluxer.nix
    ./programs/spicetify.nix
    ./programs/vesktop/default.nix
    ./programs/git.nix
    ./shell/fish.nix
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
  home.stateVersion = vars.stateVersion;

  home.packages = import ./packages.nix { inherit pkgs inputs; };

  home.sessionVariables.EDITOR = "code";

  programs.home-manager.enable = true;
}

{ pkgs, inputs, lib, vars, ... }:

let
  desktops = import ../lib/desktops.nix;
  desktop = desktops.assertValid vars.desktop;
in
{
  imports = [
    ../desktops/shared/home.nix
    (../desktops + "/${desktop}/home")
    ./editors/vscode.nix
    ./editors/doom.nix
    ./programs/ghostty.nix
    ./programs/microfetch.nix
    ./programs/firefox.nix
    ./programs/waytator.nix
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

  home.sessionVariables.EDITOR = "emacs";

  programs.home-manager.enable = true;
}

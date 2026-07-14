{ pkgs, inputs, lib, vars, noctaliaPackage, ... }:

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
    ./programs/gtk.nix
    ./programs/microfetch.nix
    ./programs/firefox.nix
    ./programs/waytator.nix
    ./programs/fluxer.nix
    ./programs/vesktop/default.nix
    ./programs/git.nix
    ./programs/ssh.nix
    ./shell/fish.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
  home.stateVersion = vars.stateVersion;

  home.packages = import ./packages.nix { inherit pkgs noctaliaPackage; };

  home.sessionVariables.EDITOR = "emacs";

  programs.home-manager.enable = true;
}

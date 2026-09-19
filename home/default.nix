{
  pkgs,
  config,
  lib,
  inputs,
  desktop,
  ...
}:

{
  imports = [
    ../desktops/shared/home.nix
    (../desktops + "/${desktop}/home")
    ../modules/lysec/cursor/home.nix
    ./editors/vscode.nix
    ./editors/doom.nix
    ./shell/fish.nix
  ]
  ++ import ../lib/import-programs.nix {
    inherit lib;
    dir = ./programs;
    exclude = [
      "firefox.nix"
    ];
  };

  home.username = config.lysec.username;
  home.homeDirectory = "/home/${config.lysec.username}";
  home.stateVersion = config.lysec.stateVersion;

  home.packages = import ./packages.nix {
    inherit pkgs inputs;
    noctaliaPackage = config.lysec.noctaliaPackage;
  };

  home.sessionVariables = {
    EDITOR = "emacs";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}

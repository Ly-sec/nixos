{
  pkgs,
  config,
  desktop,
  ...
}:

{
  imports = [
    ../desktops/shared/home.nix
    (../desktops + "/${desktop}/home")
    ../modules/lysec/cursor/home.nix
    ./editors/vscode.nix
    ./shell/fish.nix
    ./programs
  ];

  home.username = config.lysec.username;
  home.homeDirectory = "/home/${config.lysec.username}";
  home.stateVersion = config.lysec.stateVersion;

  home.packages = import ./packages.nix { inherit pkgs; };

  home.sessionVariables = {
    EDITOR = "emacs";
    VISUAL = "emacs";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
}

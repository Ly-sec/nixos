{config, ...}: let
  m = config.flake.modules;
in {
  flake.modules.nixos.user-lysec = {config, ...}: {
    home-manager.users.${config.lysec.username}.imports = [m.homeManager.user-lysec];
  };
  flake.modules.homeManager.user-lysec = {config, ...}: {
    imports = with m.homeManager; [
      emacs
      development
      vscode
      kitty
      microfetch
      ssh
      vesktop
      icons
      protonplus
      prismlauncher
      heroic
      bitwarden
      btop
      mpv
      image-tools
      screen-recorder
    ];
    home = {
      username = config.lysec.username;
      homeDirectory = "/home/${config.lysec.username}";
      stateVersion = config.lysec.stateVersion;
      sessionVariables = {
        EDITOR = "emacs";
        VISUAL = "emacs";
        TERMINAL = "kitty";
      };
    };
    programs.home-manager.enable = true;
  };
}

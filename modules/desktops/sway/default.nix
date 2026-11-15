{config, ...}: {
  flake.modules.nixos."desktop-sway" = {...}: {
    home-manager.sharedModules = [config.flake.modules.homeManager."desktop-sway"];
    programs.sway.enable = true;
    programs.sway.xwayland.enable = true;
  };
  flake.modules.homeManager."desktop-sway" = {
    pkgs,
    lib,
    config,
    ...
  }: let
    kitty = "${pkgs.kitty}/bin/kitty";
    browser = config.home.sessionVariables.BROWSER;
    noctalia = lib.getExe pkgs.noctalia;
    luciole = lib.getExe pkgs.luciole;
  in {
    wayland.windowManager.sway = {
      enable = true;
      xwayland = true;
      config = {
        modifier = "Mod4";
        terminal = kitty;
        menu = browser;

        input = {
          "*" = {
            xkb_layout = "de";
            xkb_numlock = "enabled";
            xkb_variant = "";
          };
          "type:touchpad".natural_scroll = "enabled";
        };

        gaps = {
          inner = 5;
          outer = 10;
        };

        keybindings = {
          "Mod4+Return" = "exec ${kitty}";
          "Mod4+b" = "exec ${browser}";
          "Mod4+e" = "exec ${luciole}";
          "Mod4+Control+Return" = "exec ${noctalia} msg panel-toggle launcher";
          "Mod4+Shift+q" = "kill";
          "Mod4+Shift+e" = "exit";
        };
      };

      extraConfig = ''
        exec ${noctalia}
      '';
    };
  };
}

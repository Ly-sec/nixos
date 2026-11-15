{config, ...}: {
  flake.modules.nixos."host-display-labwc" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."host-display-labwc"];
  };
  flake.modules.homeManager."host-display-labwc" = {pkgs, ...}: {
    xdg.configFile."labwc/outputs.sh".source = pkgs.writeShellScript "labwc-outputs" ''
      ${pkgs.wlr-randr}/bin/wlr-randr --output DP-1 --mode 2560x1440@359.979Hz
      ${pkgs.wlr-randr}/bin/wlr-randr --output DP-2 --mode 1920x1080@164.917Hz
    '';
  };
}

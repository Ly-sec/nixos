{config, ...}: {
  flake.modules.nixos."host-display-mango" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."host-display-mango"];
  };
  flake.modules.homeManager."host-display-mango" = {lib, ...}: {
    xdg.configFile."mango/config.conf".text = lib.mkAfter "\nmonitorrule=name:^DP-1$,width:2560,height:1440,refresh:360,x:0,y:10\n";
  };
}

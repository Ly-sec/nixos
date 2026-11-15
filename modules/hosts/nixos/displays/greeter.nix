{
  flake.modules.nixos."host-greeter" = {services.displayManager.noctalia-greeter.settings.output.layout = "DP-1:0,0; DP-2:2560,0";};
}

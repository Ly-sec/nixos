{ inputs, ... }:

{
  imports = [
    inputs.umbriel.homeModules.default
    ./settings.nix
    ./animations.nix
    ./outputs.nix
    ./input.nix
    ./layout.nix
    ./keybinds.nix
    ./rules.nix
    ./autostart.nix
    ./noctalia-include.nix
  ];

  programs.umbriel.enable = true;
}

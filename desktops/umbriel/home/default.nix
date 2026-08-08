{ inputs, ... }:

{
  imports = [
    inputs.umbriel.homeModules.default
    ./settings.nix
    ./keybinds.nix
    ./autostart.nix
    ./noctalia
  ];

  programs.umbriel.enable = true;
}

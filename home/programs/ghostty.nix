{ pkgs, config, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 11;
      font-family = "JetBrainsMono Nerd Font";

      theme = "noctalia";

      window-decoration = false;

      # Disables ligatures
      font-feature = [
        "-liga"
        "-dlig"
        "-calt"
      ];
    };
  };
}

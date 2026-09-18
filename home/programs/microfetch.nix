{ pkgs, ... }:
{
  # Uses standard ANSI colors; the terminal theme (Kitty noctalia) maps them.
  home.packages = [ pkgs.microfetch ];
}

{ pkgs, ... }:
{
  # Uses standard ANSI colors; the terminal theme (Ghostty noctalia) maps them.
  home.packages = [ pkgs.microfetch ];
}

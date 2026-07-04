{ pkgs, noctaliaPackage, ... }:

with pkgs;
[
  noctaliaPackage
  protonplus
  prismlauncher
  nautilus
  file-roller
  btop
  bibata-cursors
  mpv
  pywalfox-native
  gh
  gcc16
  llvmPackages_22.clang-tools
  just
  lefthook
  nodejs
  nim
  nixfmt
  nwg-look
  jq
  eza
  lazygit
  ripgrep
  tree
  libnotify
  wl-clipboard
  unzip
  imagemagick
  gpu-screen-recorder
  xwayland-satellite
]

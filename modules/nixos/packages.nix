{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    pavucontrol
    gnome-themes-extra
    xwayland
    ffmpeg
    mesa
    libva
    playerctl
    nh
    spicetify-cli
    ddcutil
    bluez
    
  ];
}

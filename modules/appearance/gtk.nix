{config, ...}: {
  flake.modules.nixos."gtk" = {pkgs, ...}: {
    home-manager.sharedModules = [config.flake.modules.homeManager."gtk"];
    programs.dconf.enable = true;
    environment.systemPackages = [pkgs.gnome-themes-extra];
  };
  flake.modules.homeManager."gtk" = {pkgs, ...}: {
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
    };
    home.packages = [pkgs.nwg-look];
  };
}

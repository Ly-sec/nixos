{config, ...}: {
  flake.modules.nixos."desktop-plasma" = {pkgs, ...}: {
    home-manager.sharedModules = [config.flake.modules.homeManager."desktop-plasma"];
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.konsole
      kdePackages.dolphin
    ];
  };
  flake.modules.homeManager."desktop-plasma" = {
    lib,
    pkgs,
    ...
  }: let
    noctalia = lib.getExe pkgs.noctalia;
    kwriteconfig = lib.getExe' pkgs.kdePackages.kconfig "kwriteconfig6";
  in {
    home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

    # Merge just the file-manager shortcuts into Plasma's writable configuration.
    home.activation.lucioleShortcut = lib.hm.dag.entryAfter ["installPackages"] ''
      run ${kwriteconfig} --file kglobalshortcutsrc \
        --group services --group org.kde.dolphin.desktop --key _launch none
      run ${kwriteconfig} --file kglobalshortcutsrc \
        --group services --group dev.noctalia.luciole.desktop --key _launch Meta+E
    '';

    xdg.configFile."autostart/noctalia.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Noctalia
      Comment=Noctalia shell
      Exec=${noctalia}
      X-GNOME-Autostart-enabled=true
      X-KDE-autostart-after=panel
      X-KDE-autostart-phase=2
      OnlyShowIn=KDE;
    '';
  };
}

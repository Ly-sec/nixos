{
  flake.modules.homeManager."icons" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    generateIcons = pkgs.writeShellApplication {
      name = "generate-noctalia-icons";
      runtimeInputs = [pkgs.glib pkgs.gtk3];
      text = ''
        export GSETTINGS_SCHEMA_DIR=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas
        exec ${lib.getExe pkgs.python3} ${./generate-icons.py} \
          --source ${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark \
          "$@"
      '';
    };
  in {
    home.packages = [generateIcons];

    # Keep the GTK fallback without resetting Noctalia's live GSettings selection
    # whenever Home Manager activates a generation.
    gtk.gtk3 = {
      iconTheme = null;
      extraConfig.gtk-icon-theme-name = config.gtk.iconTheme.name;
    };

    xdg.configFile."noctalia/gruvbox-icons.toml".source = (pkgs.formats.toml {}).generate "gruvbox-icons.toml" {
      theme.templates.user.gruvbox-icons = {
        input_path = "${./templates/gruvbox-icons.json}";
        output_path = "$XDG_CONFIG_HOME/noctalia/gruvbox-icons.json";
        post_hook = ''${lib.getExe generateIcons} "{{ config_dir }}/gruvbox-icons.json"'';
        hook_async = true;
      };
    };
  };
}

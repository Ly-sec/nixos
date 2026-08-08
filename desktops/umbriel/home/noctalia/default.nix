{
  config,
  lib,
  ...
}:

let
  settingsPath = "${config.xdg.stateHome}/noctalia/settings.toml";
  inputPath = "${config.xdg.configHome}/noctalia/templates/umbriel/umbriel.toml";
  outputPath = "${config.xdg.configHome}/umbriel/noctalia.toml";
in
{
  # Installed under ~/.config/noctalia/templates/umbriel/
  xdg.configFile."noctalia/templates/umbriel/umbriel.toml".source = ./umbriel.toml;

  # Umbriel pulls theme colors from the rendered include (mutable, not HM-owned).
  programs.umbriel.settings.include.files = [ "noctalia.toml" ];

  # Register the user template in Noctalia settings once (mutable state file).
  home.activation.registerUmbrielNoctaliaTemplate = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${settingsPath}"
    mkdir -p "$(dirname "$settings")"
    if [ ! -f "$settings" ]; then
      printf '%s\n' 'config_version = 12' > "$settings"
    fi
    if ! grep -qF '[theme.templates.user.umbriel]' "$settings"; then
      printf '\n[theme.templates.user.umbriel]\nenabled = true\ninput_path = "%s"\noutput_path = "%s"\n' \
        "${inputPath}" "${outputPath}" >> "$settings"
      echo "registered Noctalia user template: umbriel"
    fi
  '';
}

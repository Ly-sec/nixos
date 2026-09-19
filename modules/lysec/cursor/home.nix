{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.lysec.cursor) package theme;

  generateCursor = pkgs.writeShellApplication {
    name = "generate-bibata-cursor";
    runtimeInputs = [
      pkgs.clickgen
      pkgs.coreutils
      pkgs.imagemagick
    ];
    text = ''
      accent="''${1:-}"
      outline="''${2:-}"

      if [[ ! "$accent" =~ ^[0-9A-Fa-f]{6}$ || ! "$outline" =~ ^[0-9A-Fa-f]{6}$ ]]; then
        echo "usage: generate-bibata-cursor RRGGBB RRGGBB" >&2
        exit 2
      fi

      theme='${theme}'
      runtime_theme="$theme-$accent-$outline"
      data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
      icons_dir="$data_home/icons"
      target="$icons_dir/$runtime_theme"
      previous_theme=""

      install -dm0755 "$icons_dir"

      if [[ -L "$icons_dir/$theme" ]]; then
        candidate="$(readlink "$icons_dir/$theme")"
        if [[ "$candidate" =~ ^$theme-[0-9A-Fa-f]{6}-[0-9A-Fa-f]{6}$ ]]; then
          previous_theme="$candidate"
        fi
      fi

      if [[ ! -d "$target/cursors" ]]; then
        work_dir="$(mktemp -d "$icons_dir/.bibata-build.XXXXXX")"
        trap 'rm -rf -- "$work_dir"' EXIT

        install -dm0755 "$work_dir/bitmaps/$theme"
        cp -r ${pkgs.bibata-cursors.bitmaps}/Bibata-Modern-Ice/. "$work_dir/bitmaps/$theme/"
        chmod -R u+w "$work_dir/bitmaps/$theme"

        magick mogrify \
          -channel RGB \
          +level-colors "#$outline,#$accent" \
          -type TrueColorAlpha \
          -define png:color-type=6 \
          "$work_dir/bitmaps/$theme"/*.png

        cd "$work_dir"
        ctgen ${pkgs.bibata-cursors.src}/configs/normal/x.build.toml \
          -p x11 \
          -d "bitmaps/$theme" \
          -o "$work_dir/themes" \
          -n "$theme" \
          -c 'Bibata Modern cursor using the Noctalia palette' \
          >/dev/null

        if [[ ! -e "$target" ]]; then
          mv "themes/$theme" "$target"
        fi
      fi

      ln -sfn "$runtime_theme" "$icons_dir/$theme"

      # The previous revision may still be in use until Umbriel reloads the
      # generated config. Keep it for one cycle and prune only older themes
      # created by this helper.
      while IFS= read -r -d "" candidate; do
        candidate_name="''${candidate##*/}"
        if [[ "$candidate_name" =~ ^$theme-[0-9A-Fa-f]{6}-[0-9A-Fa-f]{6}$ \
          && "$candidate_name" != "$runtime_theme" \
          && "$candidate_name" != "$previous_theme" ]]; then
          rm -rf -- "$candidate"
        fi
      done < <(find "$icons_dir" -mindepth 1 -maxdepth 1 -type d -name "$theme-*" -print0)
    '';
  };

  cursorConfigTemplate = pkgs.writeText "bibata-cursor.toml.in" ''
    [input.cursor]
    theme = "${theme}-{{colors.primary.default.hex_stripped}}-{{colors.terminal_background.default.hex_stripped}}"
  '';

  noctaliaTemplate = (pkgs.formats.toml { }).generate "bibata-cursor.toml" {
    theme.templates.user.bibata-cursor = {
      input_path = cursorConfigTemplate;
      output_path = "$XDG_CONFIG_HOME/umbriel/bibata-cursor.toml";
      pre_hook = "${lib.getExe generateCursor} {{colors.primary.default.hex_stripped}} {{colors.terminal_background.default.hex_stripped}}";
    };
  };

  defaultIndex = pkgs.writeText "bibata-cursor-index.theme" ''
    [Icon Theme]
    Name=Default
    Inherits=${theme}
  '';
in
{
  home = {
    packages = [ generateCursor ];

    sessionVariables = {
      XCURSOR_SIZE = "24";
      XCURSOR_THEME = theme;
    };

    file.".icons/default/index.theme".source = defaultIndex;
  };

  gtk.cursorTheme = {
    inherit package;
    name = theme;
    size = 24;
  };

  xdg = {
    configFile."noctalia/bibata-cursor.toml".source = noctaliaTemplate;
    dataFile."icons/default/index.theme".source = defaultIndex;
  };

  xresources.properties = {
    "Xcursor.theme" = theme;
    "Xcursor.size" = 24;
  };
}

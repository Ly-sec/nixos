{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/19-screenshots.toml".source = (pkgs.formats.toml {}).generate "19-screenshots.toml" {
      "shell" = {
        "screenshot" = {
          "confirm_region" = true;
          "directory" = "/home/lysec/Pictures/w";
          "pipe_to_command" = false;
          "save_to_file" = false;
          "show_cursor" = true;
          "copy_to_clipboard" = true;
          "skip_annotate_on_copy_save" = false;
        };
      };
    };
  };
}

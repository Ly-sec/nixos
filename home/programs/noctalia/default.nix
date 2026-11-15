{pkgs, ...}: {
  imports = [./icons.nix];

  xdg.configFile = {
    "noctalia/palettes" = {
      source = ./palettes;
      recursive = true;
    };

    "noctalia/luciole.toml".source = (pkgs.formats.toml {}).generate "luciole-template.toml" {
      theme.templates.user.luciole = {
        # Update colors before the cursor template's synchronous generation hook.
        index = -1;
        input_path = "${./templates/luciole-colors.toml}";
        output_path = "$XDG_CONFIG_HOME/luciole/colors.toml";
      };
    };
  };
}

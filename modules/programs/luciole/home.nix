{
  flake.modules.homeManager."luciole" = {pkgs, ...}: {
    home.packages = [pkgs.luciole];
    xdg.configFile."noctalia/luciole.toml".source = (pkgs.formats.toml {}).generate "luciole-template.toml" {
      theme.templates.user.luciole = {
        index = -1;
        input_path = "${./templates/colors.toml}";
        output_path = "$XDG_CONFIG_HOME/luciole/colors.toml";
      };
    };
  };
}

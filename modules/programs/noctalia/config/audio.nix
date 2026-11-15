{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/11-audio.toml".source = (pkgs.formats.toml {}).generate "11-audio.toml" {
      "audio" = {
        "enable_sounds" = true;
        "sound_theme" = "Smooth";
        "sound_volume" = 0.3499999921768904;
      };
    };
  };
}

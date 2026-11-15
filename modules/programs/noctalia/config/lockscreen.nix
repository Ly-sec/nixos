{
  flake.modules.homeManager."noctalia" = {pkgs, ...}: {
    xdg.configFile."noctalia/41-lockscreen.toml".source = (pkgs.formats.toml {}).generate "41-lockscreen.toml" {
      "lockscreen" = {
        "blur_intensity" = 0.0;
        "fingerprint" = false;
        "tint_intensity" = 0.0;
        "transition" = [
          "stripes"
        ];
      };
    };
  };
}

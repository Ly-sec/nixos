{
  flake.modules.homeManager."desktop-umbriel" = {...}: {
    programs.umbriel = {
      settings.include.optional.files = [
        "noctalia.toml"
        "bibata-cursor.toml"
      ];
    };
  };
}

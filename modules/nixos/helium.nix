{config, ...}: {
  # Allow Noctalia's community browser template to update this policy file.
  # Keep it outside the store and leave the remaining browser policies protected.
  systemd.tmpfiles.settings."10-noctalia-chromium"."/etc/chromium/policies/managed/noctalia-color.json".f = {
    user = config.lysec.username;
    group = config.users.users.${config.lysec.username}.group;
    mode = "0644";
    argument = "{}";
  };

  programs.chromium = {
    # Helium reads Chromium's Linux enterprise-policy directory. Bare extension
    # IDs make Helium route installation and updates through its extension proxy.
    enable = true;

    homepageLocation = "https://api.noctalia.dev/repos/dashboard";
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    defaultSearchProviderSuggestURL = "https://suggestqueries.google.com/complete/search?output=chrome&q={searchTerms}";

    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
    ];

    extraOpts = {
      HomepageIsNewTabPage = false;
      RestoreOnStartup = 1;
      SearchSuggestEnabled = true;
      DefaultSearchProviderName = "Google";
      DefaultSearchProviderKeyword = "google.com";

      SiteSearchSettings = [
        {
          name = "Google";
          shortcut = "g";
          url = "https://www.google.com/search?q={searchTerms}";
          featured = true;
        }
        {
          name = "SearxNG";
          shortcut = "searx";
          url = "https://searx.org/search?q={searchTerms}";
          featured = true;
        }
        {
          name = "Nix packages";
          shortcut = "np";
          url = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
          featured = true;
        }
        {
          name = "NixOS Wiki";
          shortcut = "nw";
          url = "https://nixos.wiki/index.php?search={searchTerms}";
        }
        {
          name = "DuckDuckGo";
          shortcut = "ddg";
          url = "https://duckduckgo.com/?q={searchTerms}";
        }
      ];
    };
  };
}

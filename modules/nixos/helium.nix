{
  programs.chromium = {
    # Helium reads Chromium's Linux enterprise-policy directory. Bare extension
    # IDs make Helium route installation and updates through its extension proxy.
    enable = true;

    homepageLocation = "https://api.noctalia.dev/repos/dashboard";
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    defaultSearchProviderSuggestURL =
      "https://suggestqueries.google.com/complete/search?output=chrome&q={searchTerms}";

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

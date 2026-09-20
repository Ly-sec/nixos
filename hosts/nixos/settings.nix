{
  username = "lysec";
  hostname = "nixos";
  stateVersion = "26.11";
  system = "x86_64-linux";

  # Active compositor, change here to switch sessions.
  desktop = "umbriel";
  # desktop = "niri";

  git = {
    name = "Ly-sec";
    email = "itslysec@gmail.com";
    signingKey = "5ED4FA03AA76CA17D2D50CEC19AE90196D0BA986";
  };
}

{
  username = "lysec";
  hostname = "nixos";
  stateVersion = "26.11";
  system = "x86_64-linux";

  # Active compositor / desktop session. Override in vars.local.nix to switch.
  # Options: niri, hyprland, sway, labwc, mango, plasma
  desktop = "niri";

  git = {
    name = "Ly-sec";
    email = "itslysec@gmail.com";
    signingKey = "5ED4FA03AA76CA17D2D50CEC19AE90196D0BA986";
  };

  gpgPrivateKey = "/mnt/storage/private-key.asc";

  noctaliaI18nPushSecretFile = "/mnt/storage/noctalia-i18n-push.secret";
}

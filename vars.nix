{
  username = "lysec";
  hostname = "nixos";
  stateVersion = "25.11";
  system = "x86_64-linux";

  git = {
    name = "Ly-sec";
    email = "itslysec@gmail.com";
    signingKey = "5ED4FA03AA76CA17D2D50CEC19AE90196D0BA986";
  };

  gpgPrivateKey = "/mnt/storage/private-key.asc";
}

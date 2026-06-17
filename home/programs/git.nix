{ pkgs, lib, config, vars, ... }:

let
  gpg = "${pkgs.gnupg}/bin/gpg";
  signingKey = vars.git.signingKey;
  privateKey = vars.gpgPrivateKey;
in
{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 3600;
  };

  programs.git = {
    enable = true;
    userName = vars.git.name;
    userEmail = vars.git.email;
    signing = {
      key = signingKey;
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "openpgp";
      init.defaultBranch = "main";
    };
  };

  # Import the private key from storage if it is not already in the keyring.
  # The key file must stay outside the nix store (never commit private keys).
  home.activation.importGpgKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.gnupg"
    $DRY_RUN_CMD chmod 700 "$HOME/.gnupg"

    if [ -f ${lib.escapeShellArg privateKey} ]; then
      if ! ${gpg} --homedir "$HOME/.gnupg" --list-secret-keys ${lib.escapeShellArg signingKey} 2>/dev/null \
        | ${pkgs.gnugrep}/bin/grep -q '^sec'; then
        $DRY_RUN_CMD ${gpg} --homedir "$HOME/.gnupg" --batch --import ${lib.escapeShellArg privateKey}
      fi
    else
      echo "warning: GPG private key not found at ${privateKey}, skipping import" >&2
    fi
  '';
}

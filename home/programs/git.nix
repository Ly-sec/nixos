{ pkgs, lib, vars, ... }:

let
  gpg = "${pkgs.gnupg}/bin/gpg";
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
      key = vars.git.signingKey;
      signByDefault = true;
    };
    settings = {
      gpg.format = "openpgp";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  home.activation.importGpgKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.gnupg"
    $DRY_RUN_CMD chmod 700 "$HOME/.gnupg"

    if [ -f ${lib.escapeShellArg vars.gpgPrivateKey} ]; then
      if ! ${gpg} --homedir "$HOME/.gnupg" --list-secret-keys ${lib.escapeShellArg vars.git.signingKey} 2>/dev/null \
        | ${pkgs.gnugrep}/bin/grep -q '^sec'; then
        $DRY_RUN_CMD ${gpg} --homedir "$HOME/.gnupg" --batch --import ${lib.escapeShellArg vars.gpgPrivateKey}
      fi
    else
      echo "warning: GPG private key not found at ${vars.gpgPrivateKey}, skipping import" >&2
    fi
  '';
}

{ pkgs, lib, vars, config, ... }:

let
  gpg = "${pkgs.gnupg}/bin/gpg";
  gpgHome = config.programs.gpg.homedir;
in
{
  programs.gpg.enable = true;

  # keyboxd deadlocks here (duplicate daemon + pubring.db.lock). Use pubring.kbx instead.
  home.file."${gpgHome}/common.conf".text = ''
    # Managed by home-manager — intentionally no use-keyboxd.
  '';

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 3600;
  };

  programs.git = {
    enable = true;
    signing = {
      key = vars.git.signingKey;
      signByDefault = true;
    };
    settings = {
      user.name = vars.git.name;
      user.email = vars.git.email;
      gpg.format = "openpgp";
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  home.activation.exportGpgFromKeyboxd = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ -f "${gpgHome}/public-keys.d/pubring.db" ] && [ ! -f "${gpgHome}/pubring.kbx" ]; then
      if grep -q '^use-keyboxd' "${gpgHome}/common.conf" 2>/dev/null; then
        $DRY_RUN_CMD ${gpg} --homedir "${gpgHome}" --batch --export --export-options backup \
          > /tmp/nixos-gpg-keyboxd-migrate.gpg
      fi
    fi
  '';

  home.activation.importGpgKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${gpgHome}"
    $DRY_RUN_CMD chmod 700 "${gpgHome}"

    if [ -f /tmp/nixos-gpg-keyboxd-migrate.gpg ]; then
      $DRY_RUN_CMD gpgconf --kill keyboxd gpg-agent 2>/dev/null || true
      $DRY_RUN_CMD ${gpg} --homedir "${gpgHome}" --batch --import --import-options restore \
        < /tmp/nixos-gpg-keyboxd-migrate.gpg
      $DRY_RUN_CMD rm -f /tmp/nixos-gpg-keyboxd-migrate.gpg
    fi

    gpgKey=/run/agenix/gpg-private-key
    if [ -f "$gpgKey" ]; then
      if ! ${gpg} --homedir "${gpgHome}" --list-secret-keys ${lib.escapeShellArg vars.git.signingKey} 2>/dev/null \
        | ${pkgs.gnugrep}/bin/grep -q '^sec'; then
        $DRY_RUN_CMD ${gpg} --homedir "${gpgHome}" --batch --import "$gpgKey"
      fi
    else
      echo "warning: GPG private key not found at $gpgKey (agenix), skipping import" >&2
    fi
  '';
}

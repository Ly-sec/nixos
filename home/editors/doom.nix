{ config, inputs, lib, pkgs, ... }:

let
  doomConfigDir = "${config.xdg.configHome}/doom";
  doomLocalDir = "${config.xdg.dataHome}/doom";
  emacsDir = "${config.xdg.configHome}/emacs";
  doomBin = "${emacsDir}/bin/doom";
  doomRev = (builtins.fromJSON (builtins.readFile ../../flake.lock)).nodes.doomemacs.locked.rev;
  doomConfigSrc = ../doom;
  rsyncBin = "${pkgs.rsync}/bin/rsync";
  gitBin = "${pkgs.git}/bin/git";

  doomEnv = ''
    export DOOMDIR=${lib.escapeShellArg doomConfigDir}
    export DOOMLOCALDIR=${lib.escapeShellArg doomLocalDir}
    export EMACSDIR=${lib.escapeShellArg emacsDir}
  '';

  runDoom = pkgs.writeShellScript "run-doom" ''
    ${doomEnv}
    exec ${lib.escapeShellArg doomBin} "$@"
  '';

  wrap = binary: ''
    ${doomEnv}
    exec ${lib.escapeShellArg binary} "$@"
  '';
in
{
  home.sessionVariables = {
    DOOMDIR = doomConfigDir;
    DOOMLOCALDIR = doomLocalDir;
    EMACSDIR = emacsDir;
  };

  home.activation.doomConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target=${lib.escapeShellArg doomConfigDir}
    src=${doomConfigSrc}

    if [ -L "$target" ]; then
      $DRY_RUN_CMD rm -f "$target"
    fi
    $DRY_RUN_CMD mkdir -p "$target/themes"
    if [ -d "$target" ]; then
      $DRY_RUN_CMD chmod -R u+w "$target" 2>/dev/null || true
    fi
    $DRY_RUN_CMD ${rsyncBin} -a --delete \
      --exclude 'themes/noctalia-theme.el' \
      --chmod=u+rwX,go-w \
      "$src/" "$target/"
    if [ ! -f "$target/themes/noctalia-theme.el" ]; then
      $DRY_RUN_CMD cp "$src/themes/noctalia-theme.el" "$target/themes/noctalia-theme.el"
    fi
  '';

  # Doom must live in a writable git checkout (submodules + install/sync write to EMACSDIR).
  home.activation.doomEmacs = lib.hm.dag.entryAfter [ "doomConfig" ] ''
    target=${lib.escapeShellArg emacsDir}
    marker="$target/.nix-managed-rev"
    wanted=${lib.escapeShellArg doomRev}

    if [ ! -f "$target/bin/doom" ] || [ "$(cat "$marker" 2>/dev/null)" != "$wanted" ]; then
      echo "doom-emacs: installing ${doomRev} into $target"
      $DRY_RUN_CMD rm -rf "$target"
      $DRY_RUN_CMD ${gitBin} clone https://github.com/doomemacs/doomemacs.git "$target"
      $DRY_RUN_CMD ${gitBin} -C "$target" checkout "$wanted"
      $DRY_RUN_CMD ${gitBin} -C "$target" submodule update --init --recursive
      echo "$wanted" > "$marker"
    fi
  '';

  # First-time package install is too slow for activation; run `doom install` once yourself.
  home.activation.doomSync = lib.hm.dag.entryAfter [ "doomEmacs" ] ''
    if [ -f ${lib.escapeShellArg doomBin} ] && [ -d ${lib.escapeShellArg "${doomLocalDir}/state/profiles"} ]; then
      ${lib.escapeShellArg runDoom} -y sync
    fi
  '';

  home.packages = with pkgs; [
    (writeShellScriptBin "doom" (wrap doomBin))
    (writeShellScriptBin "emacs" (wrap "${emacs}/bin/emacs"))
    (writeShellScriptBin "emacsclient" (wrap "${emacs}/bin/emacsclient"))
    git
    fd
    gnutls
    zstd
    sqlite
    coreutils
    editorconfig-core-c
  ];
}
